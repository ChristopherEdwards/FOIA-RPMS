INHUTC22 ;DS,bar; 23 May 97 09:24; Interface Criteria date help
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 Q
 ;
HELP ; display help screens
 N X
 D HELP1("HELPX1")
 R !!?25,"Press Return to continue",X:$S($D(DTIME):DTIME,1:300)
 D HELP1("HELPX2")
 Q
 ;
HELP1(INLINE) ; Display help message and quit
 ;
 ; Input: INLINE = line tag entry for the help section
 ;
 N INI,INL
 F INI=1:1 S INL=$T(@INLINE+INI) Q:'$L($P(INL,";;",2))  D
 .S INL=$P(INL,";;",2) W !,INL
 Q
 ;
HELPX1 ; Insert help lines here for page 1
 ;;$$RELDT^INHUTC2 converts a text string containing date mnemonics and
 ;;modifiers to FileMan internal date format. This function allows a
 ;;date to be set relative to the current date based on a set of
 ;;instructions. This can be used to recalculate the date for a task
 ;;on the fly rather than asking the user to input dates or hard-code a routine.
 ;;For example, use 'BM-1' as a start date and 'EM-1' as the end date
 ;;for all of last month.
 ;; 
 ;;Call:       Set FMdate=$$RELDT^INHUTC2(text_string,opt_string,prompt)
 ;;Parameters: text_string: base_date[(+-) integer [date_modifier][@hhmmss]
 ;;            Multiple date_modifiers can be used. Example: LSA-7D+4H
 ;;                                 Base Date Formats
 ;; Mnemonic                 Description
 ;;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 ;; MM/DD/YY, etc.           Standard date input formats available with ^%DT
 ;; NOW                      Current date and time
 ;; TODAY or T               Current date
 ;; BY or EY                 Beginning or end of the current Year
 ;; BM or EM                 Beginning or end of current Month
 ;; BD or ED                 Beginning or end of current Day
 ;; SA,SU,MO,TU,WE,TH,FR     Day of the week.
 ;;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 ;;
 ;;
HELPX2 ; Insert help lines here for page 2
 ;;                                 Date Modifier Formats
 ;; Mnemonic                 Description
 ;;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 ;;@hhmmss                   Standard time input formats available with ^%DT
 ;; Y                        Years.
 ;; MO                       Months.
 ;; D                        Days. This is the default.
 ;; H                        Hours.
 ;; MI                       Minutes.
 ;; S                        Seconds.
 ;;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 ;; opt_string: Optional string of characters. Same format as ^%DT
 ;;                                 opt_string Characters
 ;; Mnemonic                 Description
 ;;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 ;; A                        Ask for input.
 ;; E                        Echo the answer.
 ;; F                        Future dates are assumed.
 ;; N                        Pure numeric input is not allowed.
 ;; O                        Time-only is allowed.
 ;; P                        Past dates are assumed.
 ;; R                        Require time input.
 ;; S                        Seconds are returned.
 ;; T                        Time input is allowed.
 ;; X                        Exact month and day is required.
 ;; U                        Return user readable date/time.
 ;;
