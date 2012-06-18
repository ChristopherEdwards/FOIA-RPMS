INHMG3 ;KN; 19 Aug 95 06:57;Script Message Generator - 'INHSG MESSAGE' TEMPLATE 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:  Script Message Generator (INHMG3)
 ;  - 'INHMG MESSAGE' Print Template
 ;
 ; DESCRIPTION:  
 ; This module is based on the code generated from the 'INHSG MESSAGE' 
 ; Print Template for the Script Generator Message file ( Print 
 ; Template #1151 ).
 ;
 ; PURPOSE: 
 ; The purpose of this module INHMG3 and its extension ( INHMG4 ) 
 ; is to build the DXS array of Mumps Code to support INHMG, INHSG1, 
 ; INHMG2 Modules.  The Mumps code will be used to search the 
 ; following globals ^INTHL7M, ^INTHL7S, ^INTHL7S for the segments, 
 ; and fields of the selected Script Generator Message.
 ;  
 ; Code begins
 K DXS
 S DXS(1,9.2)="N D N DIP S DIP(1)=$G(^INTHL7M(D0,2,D1,0)) S X=$P($G(^INRHT(+$P(DIP(1),U),0)),U)"
 S DXS(1,9.3)="S I(0)=""^INTHL7M("",J(0)=4011 F D=0:0 S (D,D1)=$O(^INTHL7M(D0,2,D)) Q:'D  I $D(^(D,0))#2 X DXS(1,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(2,9.2)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S DIP(101)=$G(^INTHL7S(D0,0)) S X=$P(DIP(101),U,2) S D0=I(0,0)"
 S DXS(3,9.2)="N D N DIP S DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P(DIP(101),U,2)"
 S DXS(3,9.3)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(3,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(3,9.4)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(3,9.3):D0>0 S X="""" S D0=I(0,0)"
 S DXS(4,9.2)="S I(101,0)=$G(D1),I(100,0)=$G(D0),DIP(101)=$G(^INTHL7S(D0,1,D1,0)),D0=$P(DIP(101),U) S:'$D(^INTHL7F(+D0,0)) D0=-1 S DIP(201)=$G(^INTHL7F(D0,0)) S X=$P(DIP(201),U,3)"
 S DXS(4,9.3)="N D N DIP X DXS(4,9.2) S D0=I(100,0) S D1=I(101,0)"
 S DXS(4,9.4)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(4,9.3) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(4,9.5)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(4,9.4):D0>0 S X="""" S D0=I(0,0)"
 S DXS(5,9.2)="S I(101,0)=$G(D1),I(100,0)=$G(D0),DIP(101)=$G(^INTHL7S(D0,1,D1,0)),D0=$P(DIP(101),U) S:'$D(^INTHL7F(+D0,0)) D0=-1 S I(200,0)=$G(D0),DIP(201)=$G(^INTHL7F(D0,0))"
 S DXS(5,9.3)="N D N DIP X DXS(5,9.2) S DIP(202)=$G(X),D0=$P(DIP(201),U,2) S:'$D(^INTHL7FT(+D0,0)) D0=-1 S DIP(301)=$G(^INTHL7FT(D0,0)) S X=$P(DIP(301),U,2) S D0=I(100,0) S D1=I(101,0)"
 S DXS(5,9.4)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(5,9.3) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(5,9.5)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(5,9.4):D0>0 S X="""" S D0=I(0,0)"
 S DXS(6,9.2)="N D N DIP S DIP(102)=$C(59)_$P($G(^DD(4010.01,.03,0)),U,3),DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,3)_"":"",2),$C(59)),X=$E(X)"
 S DXS(6,9.3)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(6,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(6,9.4)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(6,9.3):D0>0 S X="""" S D0=I(0,0)"
 S DXS(7,9.2)="N D N DIP S DIP(102)=$C(59)_$P($G(^DD(4010.01,.04,0)),U,3),DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,4)_"":"",2),$C(59)),X=$E(X)"
 S DXS(7,9.3)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(7,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(7,9.4)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(7,9.3):D0>0 S X="""" S D0=I(0,0)"
 S DXS(8,9.2)="N D N DIP S DIP(102)=$C(59)_$P($G(^DD(4010.01,.05,0)),U,3),DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,5)_"":"",2),$C(59)),X=$E(X)"
 S DXS(8,9.3)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(8,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(8,9.4)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(8,9.3):D0>0 S X="""" S D0=I(0,0)"
 S DXS(9,9.2)="N D N DIP S DIP(102)=$C(59)_$P($G(^DD(4010.01,.06,0)),U,3),DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,6)_"":"",2),$C(59)),X=$E(X)"
 S DXS(9,9.3)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(9,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(9,9.4)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(9,9.3):D0>0 S X="""" S D0=I(0,0)"
 S DXS(10,9.2)="N D N DIP S DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P($G(^INTHL7F(+$P(DIP(101),U),0)),U)"
 S DXS(10,9.3)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(10,9.2) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(10,9.4)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(10,9.3):D0>0 S X="""" S D0=I(0,0)"
 S DXS(11,9.2)="S I(101,0)=$G(D1),I(100,0)=$G(D0),DIP(101)=$G(^INTHL7S(D0,1,D1,0)),D0=$P(DIP(101),U) S:'$D(^INTHL7F(+D0,0)) D0=-1 S DIP(201)=$G(^INTHL7F(D0,""C"")) S X=$E(DIP(201),1,245)"
 S DXS(11,9.3)="N D N DIP X DXS(11,9.2) S D0=I(100,0) S D1=I(101,0)"
 S DXS(11,9.4)="S I(100)=""^INTHL7S("",J(100)=4010 F D=0:0 S (D,D1)=$O(^INTHL7S(D0,1,D)) Q:'D  I $D(^(D,0))#2 X DXS(11,9.3) X DICMX  Q:'$D(D)  S D=D1"
 S DXS(11,9.5)="S I(1,0)=$G(D1),I(0,0)=$G(D0),DIP(1)=$G(^INTHL7M(D0,1,D1,0)),D0=$P(DIP(1),U) S:'$D(^INTHL7S(+D0,0)) D0=-1 S I(101,0)=$G(D1) X DXS(11,9.4):D0>0 S X="""" S D0=I(0,0)"
 S DXS(12,9.2)="N D N DIP S DIP(101)=$G(^INTHL7S(D0,1,D1,0)) S X=$P(DIP(101),U,2)"
 G ^INHMG4
