XBDIQ0 ; IHS/ADC/GTH - Documentation for XBDIQ1 ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Documentation for XBDIQ1
 ;
 ; This routine provides a friendly front end to EN^DIQ1 and
 ; an assortment of other features.
 ;
 ; 1. Data arrays are returned into 'DIQ in a variety of
 ;    formats controlled by the parameter set into DIQ(0). 
 ;    The default is 'DIQ(FLDNUM)= external value of field
 ;    FLDNUM is the DD number of the field as used in DR.
 ;
 ; 2. Data retrieval is non-intrusive! Does not disturb the
 ;    partition.
 ;
 ; 3. Input Variables used are the same as for EN^DIQ1 with
 ;    more friendly results.
 ;
 ; 4. DR(filenumber and DA(filenumber arrays are
 ;    automatically built when needed.
 ;
 ; ENTRY POINTS
 ;
 ; ENP^XBDIQ1(DIC,DA,DR,DIQ,DIQ(0)) 
 ;    Returns 'DIQ(FLDNUM)= data for One Entry.
 ;
 ; ENPM^XBDIQ1(DIC,DA,DR,DIQ,DIQ(0))
 ;    Returns 'DIQ(DA,FLDNUM)= data for Multiple Entries.
 ;    DIC("S") can be set and used for screening entries.
 ;
 ; $$VAL^XBDIQ1(DIC,DA,DR)   
 ;    Returns External value of one field.
 ;
 ; $$VALI^XBDIQ1(DIC,DA,DR)    
 ;    Returns Internal value of one field.
 ;
 ; $$DIC^XBDIQ1(DIC)  Returns constructed DIC from
 ;    file/subfile number.
 ;
 ; PARSE^XBDIQ1(DA)
 ;    Returns a DA array from a literal string made from
 ;    Variables or Numbers mixed in descending order.
 ;    EXMP: "1,DFN,56" => DA=56,DA(1)=34,DA(2)=1 where DFN=34
 ;    also: S VAR(I)="1,DFN,56" D PARSE^XBDIQ1(VAR(I)) => as
 ;    above.
 ;
 ; EN             Returns one Entry (DR) fields.
 ;                Needs DIC,DA,DR,DIQ,DIQ(0) as set up for
 ;                calls to EN^DIQ1.
 ;
 ; ENM            Returns Multiple Entry's (DR) fields
 ;                 1) upper DA array ie: DA(1),DA(2), ...
 ;                 2) DA="" in the passing array
 ;                 3) optional DIC("S")
 ;                Needs DIC,DA,DR,DIQ,DIQ(0) as set up for
 ;                calls to EN^DIQ1.
 ;                DIQ(0)=1 by default.
 ;
 ; DIQ(0)   Format Options.
 ;
 ; DIQ(0)          If DIQ(0) is not present the default is
 ;                 set to NULL.
 ;
 ;   0 OR NULL     DIQ(FLD)=
 ;   1             DIQ(DA,FLD)=
 ;   2             DIQ(DA(x),..,DA,FLD)=
 ;   nI            DIQ(... ,FLD,"I")=internal value(s) returned
 ;   nN            NULL fields are not returned
 ;
 ;   DA can be the array .DA or a literal string in descending
 ;   order.
 ;                "1,23,45"
 ;                "1,PATDFN,BLDFN" variables will be unfolded.
 ;                BARVDA("EOBSUB")
 ;                  ("EOBSUB")="BAFCLDA,BARITDA,BAREDA"
 ;
 ;
 Q
 ;
