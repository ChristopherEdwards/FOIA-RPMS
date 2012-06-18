BIO ;IHS/CMI/MWR - CALL DDIOL TO WRITE TO DISPLAY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  WRITE TEXT TO SCREEN.
 ;
 ;---------
IO(BIIO,BIF) ; EP
 ;---> Write one line.
 ;---> Parameters:
 ;     1 - BIIO   (req) Text to be displayed; should be <70 chars.
 ;     2 - BIF    (opt) Format; Default="!!?3", pass "" to override.
 ;
 S:'$D(BIF) BIF="!!?3"
 D EN^DDIOL(BIIO,"",BIF)
 Q
