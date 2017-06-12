TIUE1012 ;IHS/MSC/MGH - Environment Check Rtn for TIU*1*1012;30-Apr-2013 16:11;DU
 ;;1.0;Text Integration Utilities;**1012**;Jun 20, 1997;Build 45
MAIN ; Check environment
 ; -- Set data for DDEFs to export:
 D SETXTMP
 ; -- Check for potential DDEF duplicates at site:
 N TIUDUPS
 D TIUDUPS(.TIUDUPS)
 ; -- If potential duplicates exist, abort install:
 I 'TIUDUPS W !,"Document Definitions look OK." Q
 S XPDABORT=1 W !,"Aborting Install..."
 Q
 ;
SETXTMP ; Set up ^XTMP global
 S ^XTMP("TIU1012",0)=3130501_U_DT
 ; -- Set basic data for new DDEFS into ^XTMP.
 ;    Reference DDEFS by NUMBER.
 ;    Number parent-to-be BEFORE child.
 ; -- DDEF Document classes:
 S ^XTMP("TIU1012","BASICS",1,"NAME")="REQUEST FOR CORRECTION/AMENDMENT OF PHI"
 S ^XTMP("TIU1012","BASICS",1,"INTTYPE")="DC"
 ; -- DDEF:
 S ^XTMP("TIU1012","BASICS",2,"NAME")="APPROVED REQUEST FOR CORRECTION/AMENDMENT OF PHI"
 S ^XTMP("TIU1012","BASICS",2,"INTTYPE")="DOC"
 S ^XTMP("TIU1012","BASICS",3,"NAME")="DENIED REQUEST FOR CORRECTION/AMENDMENT OF PHI"
 S ^XTMP("TIU1012","BASICS",3,"INTTYPE")="DOC"
 Q
 ;
TIUDUPS(TIUDUPS,SILENT) ; Set array of potential duplicates
 N NUM S (NUM,TIUDUPS)=0
 F  S NUM=$O(^XTMP("TIU1012","BASICS",NUM)) Q:'NUM  D
 . ; -- When looking for duplicates, ignore DDEF if
 . ;      previously created by this patch:
 . Q:$G(^XTMP("TIU1012","BASICS",NUM,"DONE"))
 . ; -- If site already has DDEF w/ same Name & Type as one
 . ;    we are exporting, set its number into array TIUDUPS:
 . N NAME,TYPE,TIUY S TIUY=0
 . S NAME=^XTMP("TIU1012","BASICS",NUM,"NAME"),TYPE=^XTMP("TIU1012","BASICS",NUM,"INTTYPE")
 . F  S TIUY=$O(^TIU(8925.1,"B",NAME,TIUY)) Q:+TIUY'>0  D
 . . I $P($G(^TIU(8925.1,+TIUY,0)),U,4)=TYPE S TIUDUPS(NUM)=+TIUY,TIUDUPS=1
 ; -- Write list of duplicates:
 I +TIUDUPS,'$G(SILENT) D
 . W !,"You already have the following Document Definitions exported by this patch."
 . W !,"I don't want to overwrite them. Please change their names so they no longer"
 . W !,"match the exported ones, or if you are not using them, delete them."
 . W !!,"If you change the name of a Document Definition, remember to update its Print"
 . W !,"Name, as well. For help, contact National VistA Support."
 . N NUM S NUM=0
 . F  S NUM=$O(TIUDUPS(NUM)) Q:'NUM  D
 . . W !?5,^XTMP("TIU1012","BASICS",NUM,"NAME")
 Q
