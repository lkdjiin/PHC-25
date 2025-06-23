VRAM: equ $6000
SPACE_KEY: equ 127
LEVEL: equ $f000 ; 1 easy - 2 normal - 3 hard
SCORE: equ $f002

org $f00a ; Ten bytes for variables sharing with basic.

; Initialize pseudo random indexes
  ld a, r
  ld hl, height_index
  ld (hl), a
  ld hl, shape_index
  ld (hl), a

start:
  call build_town
  call game
  ; if hl still holds $61xx it means the game was won.
  ld a, h
  ld b, $61
  cp b
  jr z, start ; next town
  ; Or game over!
  ret

; ----------------------------------------------------------------------
; Start the game. Update plane.
; Destroy all.
game:
  ld hl, 0
  ld (SCORE), hl
  ld hl, VRAM+1
game_while:
  ; Update the plane every other turn to make it two times slower than the
  ; bomb.
  ld a, (yes_or_no)
  cpl a
  ld (yes_or_no), a
  and a
  jr z, game_update_plane
  jr game_update_bomb
yes_or_no:
  db 0
game_update_plane:
  ; hl currently holds the position of the "right char" of the plane.
  ; Draw plane
  dec hl ; hl points to the left char of the plane.
  
  ld a, (LEVEL)
  ld d, 3
  cp d
  jr z, fast_fast 
  call pause
  call pause
  call pause
fast_fast:
  ld (hl), 0 ; erase
  inc hl ; To draw the new left part.
  ld (hl), 173 ; draw
  inc hl ; To draw the new right part.
  ld (hl), 174 ; draw
  ; Check if there is a collision with a building
  inc hl ; Now hl points in front of the plane
  ld a, (hl) ; Zero means no building
  and a
  jr nz, plane_fall
  dec hl
game_update_bomb:
  call bomb ; must preserve HL

  call pause
  call pause

  ; Continue until the plane reaches the bottom of the screen.
  ld a, h
  ld b, $61
  cp b
  jr nz, game_while
  ld a, l
  ld b, $f0
  cp b
  jr nz, game_while
  ; Add 512 to the score.
  push hl
  ld hl, (SCORE)
  ld de, 512
  add hl, de
  ld (SCORE), hl
  pop hl
win_or_fail:
  ret

; ----------------------------------------------------------------------
; Game over, the plane until the bottom of the screen.
; hl: VRAM position in front of the plane.
; Destroy all.
plane_fall:
  ; Add hl-VRAM to the score.
  push hl ; save plane position
  ld de, VRAM
  or a
  sbc hl, de ; get score for current town
  ld de, (SCORE)
  add hl, de ; updated score
  ld (SCORE), hl
  pop hl ; get back plane's position

  ld de, 31 ; A full line of characters, minus one.
  dec hl
plane_fall_next:
  dec hl ; Now position at the left part of the plane.
  call pause
  call pause
  call pause
  call pause
  ; Erase plane at old position.
  ld (hl), 0
  inc hl
  ld (hl), 0
  add hl, de
  ; If hl>=$6200 it means that the plane is outside of the screen.
  ; A quick way to check this is to simply compare bp high byte with $62.
  ld a, $62
  cp h
  jr z, win_or_fail
  ; Draw plane
  call pause
  ld (hl), 173 ; draw
  inc hl ; To draw the new right part.
  call pause
  ld (hl), 174 ; draw
  jp plane_fall_next
  ret

; ----------------------------------------------------------------------
; Update the bomb
; hl: The plane's position.
; Destroy de
bomb:
  push bc ; TODO not needed anymore
  push hl
  ; if bp<>0 then display bomb
  ld hl, (bp)
  ld de, 0
  or a
  sbc hl, de
  jr z, skip_bomb_display
  call display_bomb
  jr bomb_end
skip_bomb_display:
  ; else if bp=0 and space key pressed then drop a bomb
  ld hl, (bp)
  ld de, 0
  or a
  sbc hl, de
  jr nz, bomb_end

  ; read keyboard
  ld b, SPACE_KEY
  in a, ($83)
  cp b
  jr nz, bomb_end

  ; Set bp exactly one line under the plane.
  pop hl ; plane's position
  ld de, 32 ; 32 chars in a line
  add hl, de
  ld (bp), hl
  ld (bbp), hl
  or a
  sbc hl, de
  push hl
bomb_end:
  pop hl
  pop bc
  ret

; ----------------------------------------------------------------------
; Display the bomb.
display_bomb:
  ; If bp>=$6200 it means that the bomb is outside of the screen.
  ; A quick way to check this is to simply compare bp high byte with $62.
  ld hl, (bp)
  ld a, $62
  cp h
  ; if bomb is inside the screen then display it
  jr nz, display_bomb_1
  ; if bomb is outside the screen then reset its position
  ld hl, 0
  ld (bp), hl
display_bomb_1:
  ; delete old bomb at b1
  ld hl, (b1)
  ld (hl), 0
  ; b1=bp
  ld hl, (bp)
  ld (b1), hl
  ; if bp<>0 then display bomb at bp, then update bp
  ld hl, (bp)
  ld de, 0
  or a
  sbc hl, de
  jr z, display_bomb_end
  ld hl, (bp) ; draw bomb
  ld (hl), 255
  ld de, 32 ; bp+=32 (a line is 32 chars wide)
  add hl, de
  ld (bp), hl
display_bomb_end:
  ret

; ----------------------------------------------------------------------
; Build the town.
; Destroy all.
build_town:
  ; level 1: b 10 to 22 excluded
  ; level 2:b 5 to 27 excluded
  ; level 3: b 2 to 30 excluded
  ld a, (LEVEL)
  ld d, 1
  cp d
  jr nz, maybe_level_2
  ; It's level 1
  ld b, 10 ; for x=10 to 22
  ld a, 22
  ld (x_right), a
  jr town_for_x
maybe_level_2:
  ld d, 2
  cp d
  jr nz, level_3 ; It has to be level 3.
  ; It's level 2
  ld b, 5 ; for x=5 to 27
  ld a, 27
  ld (x_right), a
  jr town_for_x
level_3:
  ld b, 2 ; for x=2 to 30
  ld a, 30
  ld (x_right), a
town_for_x:
  call pause
  call rnd_height
  call rnd_shape
  ld c, 15 ; for y=15 to 10 excluded
town_for_y:
  ; mem=24576+x+y*32
  ld hl, VRAM
  ld d, 0 ; de = x
  ld e, b
  add hl, de ; hl = VRAM+x
  ex de, hl ; save temp. address in de

  ld h, 0 ; hl = y
  ld l, c

  ; hl << 5 (y*32)
  add hl, hl
  add hl, hl
  add hl, hl
  add hl, hl
  add hl, hl

  add hl, de ; now hl contains the target char address in vram.
  ld a, (shape)
  ld (hl), a
  dec c
  ld a, (height)
  cp c
  jr nz, town_for_y

  inc b
  ld a, (x_right)
  cp b
  jr nz, town_for_x
  ret

; ----------------------------------------------------------------------
; Set the memory address `height` to a pseudo random
; value each call.
; Destroy A, HL, DE
rnd_height:
  ld hl, heights
  ld d, 0
  ld a, (height_index)
  ld e, a
  add hl, de
  ld a, (hl)
  ld (height), a
  ld hl, height_index
  inc (hl)
rnd_height_end:
  ret

; ----------------------------------------------------------------------
; Set the memory address `shape` to a pseudo random
; value each call.
; Destroy A, HL, DE
rnd_shape:
  ld hl, shapes
  ld d, 0
  ld a, (shape_index)
  ld e, a
  add hl, de
  ld a, (hl)
  ld (shape), a
  ld hl, shape_index
  inc (hl)
rnd_shape_end:
  ret

; ----------------------------------------------------------------------
; Make a pause.
; Destroy nothing.
pause:
  ; push de
  ; ld e, 250
pause_loop:
  halt
  ; rst 8
  ; dec e
  ; jr nz, pause_loop
  ; pop de
  ret

height:
  db 0
height_index:
  db 0
heights: ; 256 values
  db 10,8,12,9,8,10,10,12,9,9,13,12,13,11,8,8,10,13,8,8,9,11,10,8,10,10,9,12,9,11,13,10,13,13,8,9,8,12,9,11,9,9,9,11,12,9,8,10,11,11,12,10,11,10,10,9,8,11,8,11,13,10,10,13,10,10,12,8,13,11,10,13,11,11,8,8,13,9,10,8,10,9,11,13,11,9,8,9,12,11,10,11,10,13,11,13,8,13,8,8,12,8,12,10,12,13,13,9,8,12,10,9,11,11,10,11,8,9,8,8,8,13,9,10,13,11,10,12,12,9,11,13,10,8,9,13,11,13,13,13,9,9,10,10,9,11,10,9,12,13,8,8,11,12,13,12,12,8,13,9,13,13,13,13,8,13,11,13,8,10,13,13,10,10,13,10,13,8,11,11,9,8,8,11,13,9,8,9,10,11,11,11,9,9,11,11,11,11,10,9,11,13,9,12,10,13,10,12,12,11,10,9,12,12,11,12,8,9,10,11,13,11,10,13,12,8,11,12,11,12,9,13,10,9,11,12,9,9,11,8,10,10,10,8,8,10,12,10,11,9,13,8,11,12,9,10

shape:
  db 0
shape_index:
  db 0
shapes: ; 256 values
  db 122,122,117,117,58,122,117,58,58,122,58,117,117,122,122,58,58,117,122,117,122,117,117,58,122,53,122,122,58,58,53,53,122,122,117,53,117,53,117,117,122,58,58,117,117,122,53,53,117,58,58,122,117,58,58,58,58,58,117,53,58,117,58,53,117,117,117,117,53,122,58,58,122,58,117,53,122,117,58,117,117,117,122,53,122,53,122,117,122,117,117,53,117,53,53,117,58,58,58,53,122,58,58,53,53,53,122,58,122,53,53,117,117,58,58,58,53,58,117,53,117,117,122,58,122,53,122,122,53,58,53,53,53,53,117,58,122,53,122,117,58,53,122,53,122,58,122,117,58,53,58,58,58,53,58,122,117,53,58,58,117,117,122,53,122,53,53,53,58,53,58,117,53,53,53,117,58,53,58,58,53,53,53,117,53,117,117,53,117,122,58,53,122,122,117,58,58,58,117,117,53,117,58,117,117,58,117,58,53,122,117,58,117,117,58,122,122,53,58,122,58,122,53,53,117,117,53,117,122,117,117,53,53,58,122,117,117,117,122,53,122,122,122,58,58,53,122,58,53,53,58,122,117,122,53,53

bp: ; bomb position
  dw 0
bbp: ; bomb base position
  dw 0
b1: ; old bomb position
  dw 0
x_right:
  db 0
