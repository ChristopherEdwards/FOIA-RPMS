BARFORM0 ; IHS/SD/LSL - FORMS FOR XBFORM ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 Q
 ; *********************************************************************
 ;
TEST ;;
 ;** set up variables
 D ENP^XBDIQ1(200,DUZ,".01:.116","BARU(")
 ;** setup a word processing field
 F I=1:1:5 S BARWP(101,I)="   LINE "_I_" has the value of "_I
 ;** setup form name
 S BARFORM="PW TEST"
 ;** call form editor
 D EDIT^XBFORM(BARFORM,90053.01,1000)
 ;** call array generator
 K BARFM
 S BARLSTLN=$$GEN^XBFORM(BARFORM,90053.01,1000,"BARFM(",0,0)
 Q
 ; *********************************************************************
 ;
TESTE ;;END
 Q
 ; *********************************************************************
 ;
TEST2 ; dsp a collection batch item
 K BARLSTLN,BARBL
 D ENP^XBDIQ1(90051.1101,"8,5",".01;2;5;6;7;8;11;17;101;102;201;301;403;501","BARIT(")
 S BARFORM="COL REG ITEM"
 D EDIT^XBFORM(BARFORM,90053.01,1000)
 S BARLL=$$GEN^XBFORM(BARFORM,90053.01,1000,"BARITA(",1)
 Q
 ; *********************************************************************
 ;
AR3P(BARDA) ; EP
 ; COMPARE 3P TO A/R
 K BARBL,BARARBL
 D ENP^XBDIQ1(90050.01,BARDA,".01;3;15;.1;102;103;18:20;113;201:207;101;108;112","BARBL(","I")
 S BARFORM="A/R 3P BILL COMPARE"
 S BARLSTLN=$$GEN^XBFORM(BARFORM,90053.01,1000,"BARARBL(",1,0)
 ; loop abma items
 S BARFORM="A/R 3P BILL ITEM COMPARE"
 N Z ; Z used within the form generator to refer back to the abma array
 S BAR3="" F  S BAR3=$O(ABMA(BAR3)) Q:BAR3'>0  D
 . K BARIT
 . S Z=BAR3
 . D ENP^XBDIQ1(90050.1301,"BARDA,BAR3",".01:2000","BARIT(")
 . S BARLSTLN=$$GEN^XBFORM(BARFORM,90053.01,1000,"BARARBL(",1,BARLSTLN)
 D ARRAY^XBLM("BARARBL(","BILL "_ABMA("BLNM"))
 Q
