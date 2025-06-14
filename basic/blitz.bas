20 screen 1
30 gosub 1000:rem init
60 gosub 4000:rem welcome
70 gosub 2000:rem building
80 for hy=0 to 14
90   for hx=0 to 31
100    locate hx,hy
110    z=-z
120    w=z+0.5
140    print a$(w);chr$(30)
160    if hx>28 then 180
170    if peek(24576+hx+3+hy*32)<>32 then 280
180    if inkey$<>"" and by=0 and hx<>31 then bx=hx+1:by=hy+1
190    if by>0 then gosub 3000
195    if by=0 then gosub 2500
200  next hx
210  locate 30,hy
220  print nn$;
230 next hy
240 play "l16o4cego5l8co4l16go5l4c"
250 for i=1 to 500:next i
260 s=s+32*hy+hx
270 goto 70
280 s=s+32*hy+hx
290 locate bx,b1
300 print n$;
310 gosub 5000 --- plane fall
390 if s>r then r=s
400 locate 10,1
410 color 2,,2
420 print "SCORE :";s;
425 locate 10,2
430 print "RECORD:";r;
435 for i=1 to 4:play "l48 o4 bagfecd":next i
440 for i=1 to 100
450 next i
460 r$=inkey$
470 if r$<>"" then 460
480 locate 10,5
490 print "UNE AUTRE ?";
500 r$=inkey$
510 if r$="" then 500
520 if r$<>"n" then s=0:goto 70
530 color 1,,1
540 cls
541 print fre(x)
542 print fre(x$)
550 end
1000 rem --- init
1010 dim a$(1)
1020 a$(0) = " >="
1030 a$(1) = " >-"
1035 rem pa:pause
1040 z=0.5:bx=0:by=0:b1=by:pa=25
1050 n$=" ":nn$="  "
1060 dim cr$(2):rem crash
1070 cr$(0)="b":cr$(1)="b-":cr$(2)="a"
1080 return
2000 rem --- build the town
2010 color 2,,2
2020 cls
2021 gosub 5200
2022 if pa=5 then x1=5:x2=26
2024 if pa=25 then x1=8:x2=23
2026 if pa=50 then x1=10:x2=21
2030 for x=x1 to x2
2040 c=int(rnd(time)*3)+19
2050 for y=15 to int(rnd(time)*6)+9 step -1
2060 mem=24576+x+y*32
2070 poke mem,c
2080 next y
2090 next x
2100 return
2500 rem --- short pause
2510 for i=1 to pa
2520 next i
2530 return
3000 rem --- display bomb
3010 if by>15 then by=0
3020 locate bx,b1:print n$;
3040 b1=by
3050 if by<>0 then poke 24576+bx+by*32,&h85:by=by+1
3052 if by=15 then sound 6,30:sound 7,28:sound 10,10
3055 if by=0 then sound 10,0
3060 return
4000 rem --- welcome screen
4005 cls
4007 gosub 5200
4008 print
4010 print spc(5);"OO   O    O  OOO  OOO"
4020 print spc(5);"O O  O        O     O"
4030 print spc(5);"O O  O    O   O     O"
4040 print spc(5);"OO   O    O   O    O"
4050 print spc(5);"O O  O    O   O   O"
4060 print spc(5);"O O  O    O   O   O"
4070 print spc(5);"OO   OOO  O   O   OOO"
4080 print
4090 print spc(11);"1 Jouer"
4100 print spc(11);"2 Niveau"
4110 print spc(11);"3 Regles"
4120 print spc(11);"4 Credits"
4290 r$=inkey$
4300 if r$="1" then 4990
4310 if r$="2" then 4400
4320 if r$="3" then 4600
4330 if r$="4" then 4800
4340 goto 4290
4400 rem --- options
4410 cls:print
4420 print "NIVEAU"
4430 print "======"
4440 print
4450 print "1 Izypizy"
4460 print "2 Abordable"
4470 print "3 Pan t'es mort"
4480 r$=inkey$
4490 if r$="1" then pa=50
4500 if r$="2" then pa=25
4510 if r$="3" then pa=5
4520 if r$="" then 4480
4530 goto 4990
4600 rem --- rules
4610 cls:print
4620 print "COMMENT JOUER A BLITZ"
4630 print "====================="
4640 print
4650 print "C'est la guerre !"
4660 print "Detruisez un maximum de villes"
4670 print "ennemies."
4680 print "Larguer une bombe en appuyant"
4690 print "sur n'importe quelle touche."
4700 print "Si votre avion touche un"
4710 print "immeuble, vous etes cuit."
4720 print "Si vous reussissez a atterrir,"
4730 print "vous passez a la ville suivante."
4740 r$=inkey$
4750 if r$="" then 4740
4760 goto 4000
4800 rem --- credits
4810 cls:print
4820 print "CREDITS"
4830 print "======="
4840 print:print "Xavier Nayrac 2025":print
4850 print "Portage et adaptation du jeu"
4860 print "Blitz du magazine <<MO5 jeux"
4870 print "d'action>> de 1984."
4900 r$=inkey$
4910 if r$="" then 4900
4920 goto 4000
4990 return
5000 rem --- plane fall
5005 c=0
5010 for i=hy to 14
5020   locate hx+1,i
5030   color 2,,2:print nn$;
5040   locate hx+1,i+1
5050   color 1,,2:print right$(a$(0),2);
5060   play "l8 o3 s10 "+cr$(c)
5065   c=c+1
5066   if c>2 then c=0
5070   for j=1 to 100
5080   next j
5090 next i
5100 return
5200 rem --- phrase 1
5210 play "t115s10m2000"
5220 play "o4l8d+fg+a+l4gd+l1d","o2l8d+r8d+r8d+r8d+r8gr8gr8gr8gr8"
5230 return
