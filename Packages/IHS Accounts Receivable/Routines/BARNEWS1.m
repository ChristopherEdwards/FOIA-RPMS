BARNEWS1 ; IHS/SD/LSL - NEWS ON CHANGES ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 D MAIL^BARMAIL("BAR","NEWS^BARNEWS1")
 Q
NEWS ;
 ;; 
 ;;1.  Parent Satellite file relationship start and end dates.
 ;; 
 ;;Background:
 ;; 
 ;;Satellites are moving out from under IHS parents as the 638 and self-
 ;;governance initiatives advance. Bills issued prior to or after the 
 ;;establishment must be kept with the appropriate affiliation.
 ;;Reloading or pulling up past bills must also be kept within the
 ;;proper affiliation.
 ;; 
 ;;Solution: Start and stop date fields have been added to the satellite 
 ;;definition within the Parent Satellite File of Accounts receivable.
 ;;The upload and reload coding has been changed to scan for the
 ;;appropriate parent according to the date of service of the bill.
 ;; 
 ;;2.  Bill items are to be resynchronized.
 ;; 
 ;;Background:
 ;; 
 ;;It has been found that items have come into A/R associated with the 
 ;;wrong bills or they are incomplete.
 ;; 
 ;;Solution:
 ;; 
 ;;When a bill has been edited in 3PB and/or when it is printed and/or
 ;;when it is reloaded the items within A/R are removed and the items
 ;;presented to A/R by 3PB at that time are loaded into the A/R tables.
 ;;This process will continue until the time when posting by items is
 ;;initiated or when the master integrated item file is distributed.
 ;; 
 ;;3.  Rollback to 3P bills that have been edited
 ;; 
 ;;Background:
 ;; 
 ;;3P hands to A/R the name and IEN of the 3P bills. However when a 3P
 ;;bill has been edited it changes its IEN.  A/R on a second submission
 ;;of a bill was coded to take it as the print cycle and did not change
 ;;any other fields.
 ;; 
 ;;Solution:
 ;; 
 ;;A/R now updates items, IEN, and other fields anytime 3P hands it a
 ;;bill.  The rollback command of the PAY option is now operational and
 ;;will tag a bill for rollback.  A site parameter controls whether a
 ;;rollback is to be accomplished within the posting or by the menu
 ;;option.
 ;; 
 ;;4.  Rollback breakout of payments, non-payments
 ;; 
 ;;Background:
 ;; 
 ;;3P originally wanted only the equivalent of an amount paid from A/R 
 ;;information to be used in preparing a secondary bill.  However this
 ;;put write off amounts in A/R as being reflected as payments in 3P.
 ;; 
 ;;Solution:
 ;; 
 ;;A/R now hands to 3P a complete breakout of the categories of
 ;;payments and adjustments from the history of the bill.
 ;; 
 ;;5.  Initial going live procedures being missed.
 ;; 
 ;;Background:
 ;; 
 ;;3P and A/R are integrated.  The installation instruction explained
 ;;that 3P approvals and printing of bills is to be stopped until A/R
 ;;is set-up.  Unfortunately, these instructions were not followed by
 ;;several sites.
 ;; 
 ;;Solution:
 ;; 
 ;;A new field has been added to the A/R Site Parameter file:
 ;;"ACCEPT 3P BILLS  Y/N".
 ;;This field will allow 3P to function as usual and bills will not
 ;;come into A/R until that field is set to YES.
 ;; 
 ;;6.  Standard Table Edit local numbering scheme
 ;; 
 ;;Background:
 ;; 
 ;;Sites have the ability to add 'Reasons' to their 'Categories' of
 ;;posting adjustments.  Their numbers are assigned automatically above
 ;;1000. Version 1.0,in error, allows the the end-user to edit the
 ;;centrally assigned reasons.
 ;; 
 ;;Solution:
 ;; 
 ;;Modify the code to only let them have access to the 'Reasons' they
 ;;have entered and not allow access to the centrally defined 'Reasons'.
 ;; 
 ;;7.  Batch Statistical Report
 ;; 
 ;;Background:
 ;; 
 ;;The 'BSL' accurately reports amounts posted to bills.  However, the 
 ;;balance left in the batch and what has been posted do not always
 ;;total to what was in the batch.  Money has been placed into
 ;;unallocated and or refunded throwing the balances off.
 ;; 
 ;;Solution:
 ;; 
 ;;The 'BSL' report has been modified to show 'unallocated' and
 ;;'refund' amounts so that proper balances may be obtained.
 ;; 
 ;;8.  Rollback Display of the bill's activity.
 ;; 
 ;;Background:
 ;; 
 ;;A/R had been coded to not display a bill's activity if it was 
 ;;evaluated that there were no secondary insurers on the bill.
 ;;There have been frequent instances where insurers have been added to
 ;;the patient record since the episode of care and other insurers do
 ;;exist.  The display is desired at all rollbacks.
 ;; 
 ;;Solution:
 ;; 
 ;;Disable the code that caused the skipping of the bill's activity. The
 ;;summary will appear on all bills that have amounts that can be given
 ;;to secondary insurers.
 ;; 
 ;;9.  Fractional Amounts
 ;; 
 ;;Background:
 ;; 
 ;;Prescription costs are computed on a table basis resulting in total 
 ;;costs that include fractional amounts.  Bills containing fractional
 ;;amounts cannot be posted to a zero balance.
 ;; 
 ;;Solution:
 ;; 
 ;;a.  Bill amounts received from 3P are rounded to the next cent.
 ;;b.  Item amount totals are now to be received from 3P rounded to
 ;;    the next cent.
 ;;c.  The reload of bills from 3P are rounded to the next cent.
 ;; 
 ;;10.  Provider file 6, 16, 200 resolution for Providers
 ;; 
 ;;Background:
 ;; 
 ;;The current release of RPMS has matched and merged the necessary
 ;;entries between the files.  Files 6,16 are to be discontinued.
 ;; 
 ;;Solution:
 ;; 
 ;;The pointers for 3P and A/R have been switched to use file 200.
 ;;This effects the provider entries in the A/R bills.
 ;; 
 ;;11.  Age Day Letter
 ;; 
 ;;Background:
 ;; 
 ;;Bills that have come to A/R with fractional amounts could never be
 ;;posted to zero balance and always appeared on the AGE Day Letter
 ;;report.
 ;; 
 ;;Solution:
 ;; 
 ;;Modify the code to ignore balances less than one cent.
 ;;Upload from 3P now rolls up fractional amounts to the next cent.
 ;;3P has also quit sending fractional amounts.
 ;; 
 ;;12.  Refunds not showing up on the monthly summaries.
 ;; 
 ;;Background:
 ;; 
 ;;The refund from an unallocated amount did set the transaction type to
 ;;refund but failed to set the category and did not request a reason. 
 ;;The refund from a bill set the category and reason but missed setting
 ;;the proper transaction type.
 ;; 
 ;;Solution:
 ;; 
 ;;The coding has been modified to perform refunds properly. Also, a
 ;;post init will be executed during the installation of version 1.1
 ;;which will collect the existing refund amounts from bills and 
 ;;unallocated accounts and place these amounts into the appropriate 
 ;;buckets.  
 ;; 
 ;;13.  Addition of two computed data fields.
 ;; 
 ;;1.  A/R Transactions file field P.A.R (Payment, Adjustments, Refund)
 ;;There are over 50 transaction types. The end-user has difficulty
 ;;separating those that are Payments, Adjustments, Refunds for their 
 ;;reports. This computed field returns a 1 if it is a transaction they 
 ;;want. Sort by //  'P.A.R>0
 ;; 
 ;;2.  A/R Accounts Insurer Type
 ;; 
 ;;The variable pointer was missing the link to the insurer file type 
 ;;field. This computed field was added to the data dictionary.
 ;; 
 ;;Although these fields have been added there is no reference to these 
 ;;fields in the current A/R software. They have been created to meet 
 ;;prominent deficiencies in the users ability to obtain their report 
 ;;requirements.
 ;; 
 ;;14. Some batch totals are found to be incorrect.
 ;; 
 ;;Background: 
 ;; 
 ;;The batches have not been keeping their totals properly.  The totals
 ;;are incorrectly calculated after an item is cancelled or edited.
 ;; 
 ;;Solution:
 ;; 
 ;;The appropriate trigger has been added tot he A/R COLLECTION BATCH 
 ;;dictionary and a post-init will be executed during the 1.1 install
 ;;which recalculates specific items in the batches.
 ;; 
 ;;15.  Error gets generated during the transfer of bills between
 ;;the A/R and 3P packages.
 ;;
 ;;Background: 
 ;; 
 ;;The items were being passed in a local array which can take up the
 ;;partition space.  The error would occur when a bill which a large
 ;;number of items was being passed between the packages.
 ;; 
 ;;Solution: 
 ;; 
 ;;A/R and 3P have been reprogrammed to pass the bill information inside
 ;;a temporary global so partition space is not used.
 ;; 
 ;;16.  Menu option VHF
 ;; View Host File has been added to the Manager menu.  The end-user
 ;; can now select an existing file from a directory and load it to the
 ;;Output Browser for full-screen viewing.
 ;; 
 ;; 
TEXTE ;
