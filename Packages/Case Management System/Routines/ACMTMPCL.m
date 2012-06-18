ACMTMPCL  ;IHS/TUCSON/TMJ - recompile all CMS Print templates;            
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 S ACMRECM("QFLG")=0,ACMRECM("X")="ACM" F  S ACMRECM("X")=$O(^DIPT("B",ACMRECM("X"))) Q:ACMRECM("X")=""  Q:$E(ACMRECM("X"),1,4)]"ACM"  D
 .S ACMRECM("Y")=0 F  S ACMRECM("Y")=$O(^DIPT("B",ACMRECM("X"),ACMRECM("Y"))) Q:ACMRECM("Y")=""  D
 ..S DMAX=$G(^DD("ROU")) S:DMAX="" DMAX=4000
 ..S X=$S($G(^DIPT(ACMRECM("Y"),"ROU"))]"":^DIPT(ACMRECM("Y"),"ROU"),$G(^DIPT(ACMRECM("Y"),"ROUOLD"))]"":^DIPT(ACMRECM("Y"),"ROUOLD"),1:"")
 ..Q:X=""
 ..I $E(X)="^" S X=$P(X,"^",2)
 ..S Y=ACMRECM("Y")
 ..D EN^DIPZ
 ..Q
 .Q
 K ACMRECM,X,Y
 Q
