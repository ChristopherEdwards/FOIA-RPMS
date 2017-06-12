BQI25PU1 ;GDIT/HS/ALA-Update Source ; 08 Jan 2015  12:00 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 ;
SRC ;EP - Add a source
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL,TTEXT,BJJ
 F BI=1:1 S TEXT=$T(NUM+BI) Q:TEXT=" Q"  D
 . S CIEN=$P(TEXT,";;",2)
 . S TEXT=$P($T(ARR+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.5,CIEN,ND)=VAL
 . ;
 . ; Re-Index File
 . S DIK="^BQI(90506.5,"
 . S DA=CIEN D IX1^DIK
 ;
 ; Do multiple fields (categories, clinical groups, layout items and tooltips)
 NEW CAT,LAY,REC,CIEN,DATA,CLIN,TEXT,TN,TIP,NDATA
 F BI=1:1 S CAT=$T(CAT+BI) Q:CAT=" Q"  D
 . S TEXT=$P(CAT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.5,CIEN,5,0)="^90506.55^"_TN_"^"_TN
 . S ^BQI(90506.5,CIEN,5,TN,0)=DATA
 F BI=1:1 S CLIN=$T(CLIN+BI) Q:CLIN=" Q"  D
 . S TEXT=$P(CLIN,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.5,CIEN,6,0)="^90506.65^"_TN_"^"_TN
 . S ^BQI(90506.5,CIEN,6,TN,0)=DATA
 F BI=1:1 S LAY=$T(LAY+BI) Q:LAY=" Q"  D
 . S TEXT=$P(LAY,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.5,CIEN,10,0)="^90506.51I^"_TN_"^"_TN
 . F BJ=1:1:$L(DATA,"~") D
 .. S NDATA=$P(DATA,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.5,CIEN,10,TN,ND)=VAL
 F BI=1:1 S TIP=$T(TIP+BI) Q:TIP=" Q"  D
 . S TEXT=$P(TIP,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . F BJ=1:1:$L(DATA,"~") D
 .. S NDATA=$P(DATA,"~",BJ)
 .. S ^BQI(90506.5,CIEN,10,TN,4,0)="^^"_BJ_"^"_BJ_"^"_DT
 .. S ^BQI(90506.5,CIEN,10,TN,4,BJ,0)=NDATA
 ;
 Q
 ;
NUM ;EP - Number of new sources
 ;;38
 ;;42
 ;;41
 ;;9
 Q
 ;
ARR ;EP - Array
 ;;0|Hep C^HC^^1^^^^^Hep C Default^^^^^1^^1~1|~2|Hep C^Care Mgmt - Hep C^^90505.1231^90505.3231~3|BQI GET CARE MGMT LIST~Patient"" + (char)29 + ""Hep C"~4|BQI GET CARE MGMT VIEW~~~Hep C
 ;;0|Register^RG^4^^^^^^Register Default^1^^^^^1^^REG
 ;;0|Men's Health^MH^^^^^^^^1
 ;;0|Pediatric^P^^^^^^^^1
 Q
 ;
CAT ;EP - Any Categories
 Q
 ;
CLIN ;EP - Any Clinical Groups
 Q
 ;
LAY ;EP - Any layout items
 Q
 ;
TIP ;EP - Tooltips
 Q
