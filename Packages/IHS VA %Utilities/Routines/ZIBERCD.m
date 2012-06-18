ZIBERCD ;DJM;DISPLAY ERROR CODE DEFINITIONS;[ 8/13/89  4:00 PM ]
 ; COPYRIGHT MICRONETICS DESIGN CORP @1990
 S $ZT="ERR^ZIBERCD"
 W !?10,$P($P($ZV,","),"-")," - Error Code Description Utility"
 N EC,EXP,I
CODE ;
 W !!,"Error code: " R EC G:EC="^Q"!(EC="^q")!("^"[EC) EXIT
 G MM:EC?1.N1":"1.N,ZV:EC?1.N,TXT:EC?1"<"5U1">",DISP:EC?5U
 W !,*7,?5,"Enter error code in following format:"
 W !,?7,"major:minor",?28,"Example:   4:1"
 W !,?7,"<text>",?28,"Example:   <SYNTX>"
 W !,?7,"nnn",?28,"Error code from $ZVERIFY(), ex:  21"
 G CODE
MM ;major:minor
 S EC=$P(EC,":")_$P(EC,":",2) G DISP
ZV ;$ZV
 S EC=99_EC G DISP
TXT ;<text>
 S EC=$E(EC,2,6)
DISP ;
 S EXP=$T(@EC) I EXP="" W *7," ... no such error code on file" G CODE
 W !,?5,$P(EXP,";",2,99)
 F I=1:1 S EXP=$T(@EC+I) Q:EXP=""!($P(EXP," ")'="")  W !,?5,$P(EXP,";",2,99)
 G CODE
EXIT ;
 Q
ERR ;
 I $F($ZE,"<INRPT>") U 0 W !!,"...Aborted." D EXIT V 0:$J:$ZB($V(0,$J,2),#0400,7):2
 ZQ
 ;error codes
21 ; missing parenthesis
22 ; missing or bad colon 
23 ; missing or bad equal 
24 ; missing or bad local variable
25 ; missing or bad global variable
26 ; missing or bad function
27 ; missing or bad routine name 
28 ; missing or bad routine label 
29 ; missing or bad routine displacement 
210 ; indirect argument error 
211 ; argument condition error 
212 ; bad argument delimiter 
213 ; bad command 
30 ; bad special variable name
31 ; bad system function
32 ; bad local variable name
33 ; bad global variable
34 ; bad string constant
35 ; bad numeric constant
36 ; unbalanced parenthesis
37 ; invalid systax in term
38 ; bad operator
39 ; bad delimiter
40 ; undefined local variable 
41 ; undefined global variable 
42 ; undefined routine label 
43 ; undefined routine name
44 ; bad naked reference 
45 ; non-existant device 
46 ; unsubscripted local reference required 
47 ; variable reference required.. no expressions 
48 ; zload/zremove command not inside of execute string
49 ; undefined uci reference 
410 ; insertion of null line is illegal
411 ; unknown data type 
412 ; missing parameter 
413 ; undefined system reference 
414 ; global access protection violation 
415 ; VIEW command restriction
416 ; ZCALL error
417 ; Formal List not entered via DO command
418 ; QUIT with argument inside FOR scope
419 ; QUIT with argument, but routine not extrinsic
420 ; argumentless QUIT, but routine was extrinsic
421 ; end of extrinsic subroutine encountered without QUIT parm
422 ; label requires a Formal List
423 ; Actual List contains more parms than Formal List
424 ; Formal List parameter is subscripted variable
425 ; duplicate variable name in Formal List
426 ; passing a value by reference in JOB command not allowed
50 ; string exceeded maximum length
 ;    4092 for locals, 255 for globals
51 ; select function error (all elements evaluated to FALSE)
52 ; attempt to divide by zero 
53 ; negative number where only zero or positive values allowed
54 ; maximum number 
55 ; attempt to access a non-opened device 
56 ; maximum memory 
57 ; string value required 
58 ; name indirection resulted in null value 
59 ; name indirection resolved into more than pure variable name 
 ;   ex: SET X=@Y    where Y="ABC+2"  (the '+2' is illegal)
510 ; selected partition not active ($VIEW) 
511 ; invalid VIEW/$VIEW() parameter 
512 ; function parameter out of range 
513 ; subscript contains $C(0), or is null, or total global reference
 ; exceeds 255 characters (including delimiters)
514 ; attempt to read/write file when file not opened for that access
 ; ex: writing to a file that is opened for input
 ;     reading from a file that is opened for output
 ;     reading from a file that is opened for input but was not found
 ;       during open processing ($ZA/$ZB indicate if file was found)
515 ; invalid kanji or compressed shiftjis char 
516 ; not allowed to write to block 0
517 ; invalid use of shared mode on VIEW buffer
60 ; break key depressed 
61 ; attempt to exceed partition size limit set at 'logon' time
62 ; halt command executed 
63 ; lock table full 
64 ; BREAK command detected
65 ; expression stack overflowed (expression too complex or operands of
 ; string operations too long)
66 ; system stack overflow (DO/XECUTE/INDIRECTION nesting is too deep)
67 ; old pcode.. need to ZLOAD and ZSAVE (run the %RELOAD utility)
68 ; ddp error
 ;   can be caused by: SET X="XECUTE X" X X
69 ; reserved for DDP internal use
610 ; DDP database access inhibited
611 ; MUMPS to MUMPS communication failure
612 ; I/O error on terminal operation
613 ; I/O error on magnetic tape operation
614 ; pcode too long to fit in one block
615 ; ZQUIT error
616 ; DDP circuit disabled
71 ; bad block type in global directory block
72 ; bad block type in pointer block
73 ; bad block type in global data block
74 ; bad block type in extended global data block
75 ; bad block type in routine directory block
76 ; bad block type in routine header block
77 ; bad block type in routine block
78 ; bad block type in map block
79 ; bad block type in journal block
710 ; bad block type in sequential-block-processor block
711 ; hardware i/o error (unable to read/write database block)
712 ; disk full (if this occurs on a SET of a global variable, you MUST
 ; use ^VALIDATE in Manager's UCI to validate the global since it
 ; is likely that the global has become corrupt since the SET did
 ; not complete normally (you may need to use ^DBFIX to correct)
713 ; mismatch of block number id in block header
714 ; global data/pointer block 'string+key' is too long, proper
 ; block split can't be performed
715 ; unable to open database 
716 ; block being freed already marked as free 
 ; use ^VALIDATE  and ^DBFIX in manager's UCI to correct problem
717 ; invalid block number to driver
BKERR ; BREAK command was executed 
CMMND ; illegal or undefined command 
CLOBR ; zload/zremove command not inside execute statement
DDPER ; ddp error
DIVER ; attempt to divide by zero 
DKFUL ; all space on the disk has been exhausted 
DKHER ; disk physical i/o error (can't read/write a block in database)
DKSER ; incorrect block type in block header (ex: reading in a 'data'
 ; block but header in block indicates a 'directory' block)
 ; use ^VALIDATE and ^DBFIX in manager's UCI to correct problem
DPARM ; invalid use of parameter passing
DSCON ; telephone associated with the device has been disconnected
FUNCT ; illegal or undefined function 
INDER ; invalid use of the indirection operator 
INRPT ; control-c or 'break' key detected 
ISYNT ; invalid syntax of a line being ZINERTed into a routine
LINER ; reference made to a non-existent label 
MAPER ; blk being freed already marked as free 
MINUS ; positive number was expected 
MODER ; read/write to file when incorrect read/write mode 
MSMCX ; in memory communication path between tasks has been interrupted
MTERR ; magnetic tape Inpt/Output error
MXNUM ; number is greater than maximum allowed 
MXMEM ; invalid memory specification in VIEW cmnd
MXSTR ; string exceeds maximum length 
NAKED ; naked reference is invalid 
NODEV ; attempt to open an undefined device 
NOMEM ; attempt to access a nonexistant or protected memory location
NOPEN ; attempt to use an unopened device 
NOPGM ; routine not found in directory 
NOSYS ; reference to a non-existent volume group through extended global notation
NOUCI ; reference to a non-existent UCI through extended global notation
PCERR ; invalid post-conditioned 
PGMOV ; no memory left in partition 
PLDER ; old pcode.. need to ZLOAD and ZSAVE (run the %RELOAD utility)
SBSCR ; invalid subscript specfication 
SYNTX ; invalid syntax in expression, command, etc
SYSTM ; system error (should not occur) 
UNDEF ; local or global reference is undefined 
PROT ; access protection violation
SBSCR ; invalid subscript in a local or global variable
STKOV ; system stack has overflowed due to nested indirection, program loop, etc.
SYNTX ; a syntax error has been encountered by the interperter
SYSTM ; an internal MUMPS error, shutdown system and reboot
VWERR ; invalid use of the shared VIEW buffer mode
ZCERR ; old pcode.. need to ZLOAD and ZSAVE
ZLZSV ; old pcode.. need to ZLOAD and ZSAVE
BADCH ; invalid kanji/shiftjis character 
99 ; buffer validation error codes 
991 ; unknown block type 
992 ; unknown data type in block 
993 ; block type mis-match of descendent block 
994 ; block not marked allocated in map block 
995 ; right hand link doesnt match next downlink of ptr 
996 ; block number field in block is incorrect
9910 ; non-zero common count for leading key in blk 
9911 ; zero length unique part of key 
9912 ; common > common+unique of previous key 
9920 ; length of leading key doesnt match expected value 
9921 ; leading key doesnt match expected value 
9930 ; keys not in ascending order 
9931 ; key not higher than high key in subtree 
9940 ; hdrnext() inconsistent with actual end 
9950 ; zero pointer to lower level 
9951 ; cyclic loop in pointer block(s)
9952 ; cyclic loop in right link of routine blocks
9960 ; incorrect offset to first free slot in map block 
9961 ; incorrect free count in map block 
9963 ; map block in illegal location (valid: 1, 513, ... 512*n+1)
9964 ; map block not allocated to SYSTEM
