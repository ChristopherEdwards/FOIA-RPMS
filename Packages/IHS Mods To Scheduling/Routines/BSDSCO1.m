BSDSCO1 ; IHS/ANMC/LJF - PT HIST ASSIGN LIST TEMPLATE ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC HIST PT ASSIGN")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCO1",$J),^TMP("BSDSCO11",$J)
 D GUIR^XBLM("IHS^SCRPO1","^TMP(""BSDSCO11"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCO11",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCO1",$J,X,0)=^TMP("BSDSCO11",$J,X)
 K ^TMP("BSDSCO11",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D END^SCRPW50 K ^TMP("BSDSCO1",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SHDR(SCX) ;EP; Print report subheader
 ; called by SHDR^SCRPO1
 ;Input: SCX='D' for detail, 'S' for summary
 Q:SCOUT
 I SCX="S" D  Q
 .W !!?62,"Category",?76,"Count",?84,"Percent"
 .W !?30,$E(SCLINE,1,40),"   --------  --------"
 .Q
 W !?20,"Pat.",?28,"Age",?94,"Enrolled",!,"Patient Name"
 W ?20,"Id.",?28,"Group",?37,"Sex",?43,"Team",?57,"Provider"
 W ?73,"Team Position",?89,"PC?",?94,"Clinic",?110,"Act. Date"
 W ?122,"Inac. Date",!
 W "------------------  ------  -------  ----  ------------  --------------  --------------  ---  --------------  ----------  ----------"
 Q
 ;
