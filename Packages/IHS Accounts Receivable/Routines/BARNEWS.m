BARNEWS ; IHS/SD/LSL - NEWS ON CHANGES ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 D MAIL^BARMAIL("BAR","NEWS^BARNEWS")
 Q
NEWS ;
 ;; Notes on Accounts Receivable version 1.1
 ;;
 ;; These notes exist in the help frames of the UA - User Assistance
 ;;Menu - Version 1.1
 ;; 
 ;;A/R MANAGER ACTION ITEMS
 ;; 
 ;;Only a few 'action items' need to be accomplished by the A/R Manager.
 ;;These are 'MANDATORY ACTION ITEMS'.
 ;; 
 ;;**1** "Parent Satellite Parameters" "Start & Stop Dates."
 ;; 
 ;;WHEN ADDING NEW SATELLITES
 ;;
 ;;The A/R manager must edit the "Parent Satellite Parameters" file
 ;;and enter appropriate Start and Stop Dates for the satellites. This
 ;;affects which parent facility bills are loaded and/or reloaded into
 ;;from Third Party Billing.
 ;; 
 ;;**2** "Site Parameter File" "Accept 3P Bills"
 ;; 
 ;;The Site Parameter file needs to be reviewed by the A/R Manager to 
 ;;insure the proper setting of this field.
 ;;
 ;;IMPORTANT NOTE: Bills will NOT come over from Third Party if this
 ;;parameter is not set to 'YES'.
 ;; 
 ;;**3**  "BILL FILE ERROR SCAN" 
 ;; 
 ;;A new menu option has been added on the A/R manager's menu called
 ;;Bill File Error Scan. This option will examine all bills in the 
 ;;A/R Bill File for the selected date range, looking for various
 ;;error conditions including small balance, negative balance, and 3P
 ;;mis-matches. New reports have been added to report on the various
 ;;error conditions.
 ;;
 ;;This option should be run after the installation of version 1.1 and
 ;;then at periodic intervals to insure proper rollbacks.
 ;; 
 ;;**4** Enable 3P Rollback from Posting Menus.
 ;; 
 ;;Rollback to 3P from the posting menus has been added. A new Site
 ;;parameter has been added called 'Roll Over During Posting'. The
 ;;choices are 'Yes', 'No', and 'Ask'. If answered 'Ask', users will be
 ;;asked if they want to roll over during posting. If answered 'yes' 
 ;;A/R Bills posted to a zero balance will immediately roll over to 
 ;;Third Party Billing. If answered 'no', roll over will have to be
 ;;accomplished by the 'Roll Back Bills to 3-Party' menu option.
 ;; 
 ;;**5**  Account Statements Menu option
 ;;
 ;;A new menu option has been added to generate monthly statements for
 ;;patient or non-beneficiary accounts. Accounts must be flagged with
 ;;the 'Flag Accounts' option before statements will be generated. 
 ;;When run the first time, the option will look back 30 days for all
 ;;flagged accounts and list the beginning balance, all transactions
 ;;for the 30 day time period, and the ending account balance. If the
 ;;'Print Account Statements' option is run on following days, the 
 ;;account will not be included again until 30 days have passed since
 ;;the last statement. 
 ;;
