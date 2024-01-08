REM DIMENSION OUR ARRAYS
0 DIM F1$(1),F2$((INT(ADR(F1$)/1024)+1)*1024-ADR(F1$)+8),C1$(255),C2$(255),C3$(255),C4$(255),B$(1600),R(40):H=1

REM SETUP RANDOM ARRAY
1 R(39)=39:FOR I=38 TO 0 STEP -1:R(I)=I:V=INT(RND(0)*(39-I))+I:Y=R(I):R(I)=R(V):R(V)=Y:NEXT I

REM CLEAR B$, GET SCREEN LOCATION, POINT ATARI TO CHARSET
2 B$=CHR$(0):B$(1600)=B$:B$(2)=B$:Z=PEEK(88)+256*PEEK(89):POKE 756,ADR(C1$)/256

REM CREATE CUSTOM CHARSET SOURCE BUFFER
3 W=ADR(B$)+8:FOR Y=W TO W+800 STEP 400:L=Z+880:FOR I=1 TO 8:READ C:POKE Y+I,C:POKE Y+192+I,C:NEXT I:NEXT Y

REM CLEAR CURSOR, SETUP SOURCE VARS FOR COPYING 3 SNOWFLAKE TYPES FROM BUFFER
4 POKE 94,0:POKE 752,1:W=ADR(C4$):E=57606:A=806:B=506:C=6:D=121

REM THE SNOWFALL MAGIC HAPPENS HERE! COPY 192 BYTES FROM THE BUFFER TO THE THREE ROWS OF CHARSETS
5 C1$=B$(A,A+191):A=A-1+(A=801)*191:C2$=B$(B,B+191):B=B-2+(B=402)*190:C3$=B$(C,C+191):C=C-3+(C=3)*192

REM ON FIRST RUN, INITIALIZE. SLOWLY GROW SNOW AT BOTTOM OF SCREEN
6 ON H GOTO 7:POKE L+R(M),D:M=M+1:ON M<40 GOTO 5:M=0:D=D+1:ON D<129 GOTO 5:D=121:L=L-40:ON L>Z GOTO 5:RUN

REM INITIALIZE SCREEN BY DRAWING COLUMNS OF CONSECUTIVE CHARS
7 H=0:M=0:FOR I=0 TO 39:POKE Z+920+I,128:V=INT(RND(0)*24)+1:T=(I-3*INT(I/3))*32:FOR Y=0 TO 880 STEP 40

REM DRAW THE NEXT CONSECUTIVE CHARACTER, LOOPING IF IT REACHES THE END
8 POKE Y+Z+I,V+T:V=V+1:IF V>24 THEN V=1

REM LOOP FOR COLUMN DRAWING, THEN PRINT "LET IT SNOW" 3 TIMES
9 NEXT Y:NEXT I:FOR I=0 TO 2:POSITION 7+I*7,6+I*3:?"let it snow":NEXT I

REM COPY THE ALPHABET CHARS FROM ROM TO OUR NEW LOCATION FOR "LET IT SNOW"
10 FOR I=8 TO 192:POKE W+I,PEEK(E+I):NEXT I

REM CREATE THE STAIR STEPPING CHARS THAT REPRESENT A GROWING LINE OF SNOW
11 FOR Y=0 TO 6:FOR I=1 TO 8:POKE W+193+(8*Y)+I,255*(I>7-Y):NEXT I:NEXT Y:GOTO 5

REM DATA FOR OUR 3 SNOWFLAKE CHARACTERS
12 DATA 16,84,214,56,214,84,16,0, 0,16,84,56,84,16,0,0, 0,0,16,56,16,0,0,0