10 clear 100,&hf000
20 cls
30 gosub 1000:rem init
100 print "Chargement..."
110 for k=1 to 921
120 read a$
130 poke &hf00a+(k-1),val("&h"+a$)
140 next k
200 gosub 4000:rem welcome
210 screen 2,1,1
220 cls
230 exec &hf00a
240 screen 1
250 cls
280 s=peek(&hf003)*256+peek(&hf002)
390 if s>r then r=s
400 locate 10,1
420 print "SCORE :";s;
430 locate 10,2
440 print "RECORD:";r;
480 locate 10,5
490 print "UNE AUTRE ?";
500 for i=1 to 8:r$=inkey$:next i
510 r$=inkey$
520 if r$="" then 510
530 if r$=" " then 510
540 if r$="o" then s=0:goto 200
550 color 1,,1
560 cls
570 end
1000 rem --- init
1010 poke &hf000, 2:rem level
1020 r=0:rem record
1030 return
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
4490 if r$="1" then poke &hf000, 1
4500 if r$="2" then poke &hf000, 2
4510 if r$="3" then poke &hf000, 3
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
4860 print "Blitz du livre <<MO5 jeux"
4870 print "d'action>> de 1984."
4900 r$=inkey$
4910 if r$="" then 4900
4920 goto 4000
4990 return
5200 rem --- phrase 1
5210 play "t115s10m2000"
5220 play "o4l8d+fg+a+l4gd+l1d","o2l8d+r8d+r8d+r8d+r8gr8gr8gr8gr8"
5230 return
9000 data ed,5f,21,99,f1,77,21,9b,f2,77,cd,1b,f1,cd,21,f0,7c,06,61,b8
9001 data 28,f4,c9,21,00,00,22,02,f0,21,01,60,3a,36,f0,2f,32,36,f0,a7
9002 data 28,03,18,21,00,2b,3a,00,f0,16,03,ba,28,09,cd,96,f1,cd,96,f1
9003 data cd,96,f1,36,00,23,36,ad,23,36,ae,23,7e,a7,20,23,2b,cd,b4,f0
9004 data cd,96,f1,cd,96,f1,7c,06,61,b8,20,c4,7d,06,f0,b8,20,be,e5,2a
9005 data 02,f0,11,00,02,19,22,02,f0,e1,c9,e5,11,00,60,b7,ed,52,ed,5b
9006 data 02,f0,19,22,02,f0,e1,11,1f,00,2b,2b,cd,96,f1,cd,96,f1,cd,96
9007 data f1,cd,96,f1,36,00,23,36,00,19,3e,62,bc,28,d3,cd,96,f1,36,ad
9008 data 23,cd,96,f1,36,ae,c3,8d,f0,c9,c5,e5,2a,9c,f3,11,00,00,b7,ed
9009 data 52,28,05,cd,ea,f0,18,21,2a,9c,f3,11,00,00,b7,ed,52,20,16,06
9010 data 7f,db,83,b8,20,0f,e1,11,20,00,19,22,9c,f3,22,9e,f3,b7,ed,52
9011 data e5,e1,c1,c9,2a,9c,f3,3e,62,bc,20,06,21,00,00,22,9c,f3,2a,a0
9012 data f3,36,00,2a,9c,f3,22,a0,f3,2a,9c,f3,11,00,00,b7,ed,52,28,0c
9013 data 2a,9c,f3,36,ff,11,20,00,19,22,9c,f3,c9,3a,00,f0,16,01,ba,20
9014 data 09,06,0a,3e,16,32,a2,f3,18,15,16,02,ba,20,09,06,05,3e,1b,32
9015 data a2,f3,18,07,06,02,3e,1e,32,a2,f3,cd,96,f1,cd,70,f1,cd,83,f1
9016 data 0e,0f,21,00,60,16,00,58,19,eb,26,00,69,29,29,29,29,29,19,3a
9017 data 9a,f2,77,0d,3a,98,f1,b9,20,e4,04,3a,a2,f3,b8,20,d2,c9,21,9a
9018 data f1,16,00,3a,99,f1,5f,19,7e,32,98,f1,21,99,f1,34,c9,21,9c,f2
9019 data 16,00,3a,9b,f2,5f,19,7e,32,9a,f2,21,9b,f2,34,c9,76,c9,00,00
9020 data 0a,08,0c,09,08,0a,0a,0c,09,09,0d,0c,0d,0b,08,08,0a,0d,08,08
9021 data 09,0b,0a,08,0a,0a,09,0c,09,0b,0d,0a,0d,0d,08,09,08,0c,09,0b
9022 data 09,09,09,0b,0c,09,08,0a,0b,0b,0c,0a,0b,0a,0a,09,08,0b,08,0b
9023 data 0d,0a,0a,0d,0a,0a,0c,08,0d,0b,0a,0d,0b,0b,08,08,0d,09,0a,08
9024 data 0a,09,0b,0d,0b,09,08,09,0c,0b,0a,0b,0a,0d,0b,0d,08,0d,08,08
9025 data 0c,08,0c,0a,0c,0d,0d,09,08,0c,0a,09,0b,0b,0a,0b,08,09,08,08
9026 data 08,0d,09,0a,0d,0b,0a,0c,0c,09,0b,0d,0a,08,09,0d,0b,0d,0d,0d
9027 data 09,09,0a,0a,09,0b,0a,09,0c,0d,08,08,0b,0c,0d,0c,0c,08,0d,09
9028 data 0d,0d,0d,0d,08,0d,0b,0d,08,0a,0d,0d,0a,0a,0d,0a,0d,08,0b,0b
9029 data 09,08,08,0b,0d,09,08,09,0a,0b,0b,0b,09,09,0b,0b,0b,0b,0a,09
9030 data 0b,0d,09,0c,0a,0d,0a,0c,0c,0b,0a,09,0c,0c,0b,0c,08,09,0a,0b
9031 data 0d,0b,0a,0d,0c,08,0b,0c,0b,0c,09,0d,0a,09,0b,0c,09,09,0b,08
9032 data 0a,0a,0a,08,08,0a,0c,0a,0b,09,0d,08,0b,0c,09,0a,00,00,7a,7a
9033 data 75,75,3a,7a,75,3a,3a,7a,3a,75,75,7a,7a,3a,3a,75,7a,75,7a,75
9034 data 75,3a,7a,35,7a,7a,3a,3a,35,35,7a,7a,75,35,75,35,75,75,7a,3a
9035 data 3a,75,75,7a,35,35,75,3a,3a,7a,75,3a,3a,3a,3a,3a,75,35,3a,75
9036 data 3a,35,75,75,75,75,35,7a,3a,3a,7a,3a,75,35,7a,75,3a,75,75,75
9037 data 7a,35,7a,35,7a,75,7a,75,75,35,75,35,35,75,3a,3a,3a,35,7a,3a
9038 data 3a,35,35,35,7a,3a,7a,35,35,75,75,3a,3a,3a,35,3a,75,35,75,75
9039 data 7a,3a,7a,35,7a,7a,35,3a,35,35,35,35,75,3a,7a,35,7a,75,3a,35
9040 data 7a,35,7a,3a,7a,75,3a,35,3a,3a,3a,35,3a,7a,75,35,3a,3a,75,75
9041 data 7a,35,7a,35,35,35,3a,35,3a,75,35,35,35,75,3a,35,3a,3a,35,35
9042 data 35,75,35,75,75,35,75,7a,3a,35,7a,7a,75,3a,3a,3a,75,75,35,75
9043 data 3a,75,75,3a,75,3a,35,7a,75,3a,75,75,3a,7a,7a,35,3a,7a,3a,7a
9044 data 35,35,75,75,35,75,7a,75,75,35,35,3a,7a,75,75,75,7a,35,7a,7a
9045 data 7a,3a,3a,35,7a,3a,35,35,3a,7a,75,7a,35,35,00,00,00,00,00,00
9046 data 00
