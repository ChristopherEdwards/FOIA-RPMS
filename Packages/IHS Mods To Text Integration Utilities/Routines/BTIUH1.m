BTIUH1 ; IHS/ITSC/LJF - INTRO TEXT ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
EED ;EP; - intro text for enter/edit document
 D ^XBCLS D MSG($$SP(25)_"ENTER/EDIT DOCUMENT",2,0,0)
 D MSG("FUNCTION:  Use to add new documents or finish ones you've started.",2,0,0)
 D MSG(" CHOICES:  Select Patient, Document Title, and PCC Visit.",1,0,0)
 D MSG($$SP(11)_"You can add a new visit, if necessary.",1,0,0)
 Q
 ;
IPD ;EP; intro text for individual pat docs
 D ^XBCLS D MSG($$SP(20)_"INDIVIDUAL PATIENT'S DOCUMENTS",2,0,0)
 D MSG("FUNCTION:  Use to review all documents for a patient within a date range.",2,0,0)
 D MSG(" CHOICES:  Select Patient, Date Range, Sort (by Reference date or by",1,0,0)
 D MSG($$SP(11)_"Visit Date), and Format (List of Titles or Full Text).",1,2,0)
 Q
 ;
MPD ;EP; intro text for multiple pat docs
 D ^XBCLS D MSG($$SP(20)_"MULTIPLE PATIENT DOCUMENTS",2,0,0)
 D MSG("FUNCTION:  Use to review selected documents.",2,0,0)
 D MSG(" CHOICES:  Select Document Status (unsigned, completed, amended, etc.);",1,0,0)
 D MSG($$SP(11)_"then select Document Type (document class grouping);",1,0,0)
 D MSG($$SP(11)_"then select Search Category (patient, author, service, title, etc.).",1,0,0)
 D MSG($$SP(11)_"At any selection prompt, you can choose ALL.",1,0,0)
 Q
 ;
IDS ;EP; intro for individual pat disch summ
 D ^XBCLS D MSG($$SP(20)_"INDIVIDUAL PATIENT DISCHARGE SUMMARY",2,0,0)
 D MSG("FUNCTION:  Use to view one discharge summary for one patient.",2,0,0)
 D MSG(" CHOICES:  Discharge Summaries are listed, 5 at a time, in descending order.",1,0,0)
 D MSG($$SP(11)_"Choose one from list to view.",1,0,0)
 Q
 ;
MDS ;EP; intro text for multiple pat disch summaries
 D ^XBCLS D MSG($$SP(15)_"MULTIPLE PATIENT DISCHARGE SUMMARIES",2,0,0)
 D MSG("FUNCTION:  Use to review selected discharge summaries.",2,0,0)
 D MSG(" CHOICES:  Select Document Status (unsigned, completed, amended, etc.);",1,0,0)
 D MSG($$SP(11)_"then select Discharge Summary Type (Discharge, Interim or Transfer).",1,0,0)
 D MSG($$SP(11)_"then select Search Category (patient, author, service, title, etc.).",1,0,0)
 D MSG($$SP(11)_"At any selection prompt, you can choose ALL.",1,0,0)
 Q
 ;
LNT ;EP; intro text for list notes by title
 D ^XBCLS D MSG($$SP(20)_"LIST NOTES BY TITLE",2,0,0)
 D MSG("FUNCTION:  Use to view all progress notes for all patients with the same title.",2,0,0)
 D MSG(" CHOICES:  Select title or titles to view; then select date range.",1,0,0)
 Q
 ;
RPN ;EP; intro for review progress notes for patient
 D ^XBCLS D MSG($$SP(20)_"REVIEW PROGRESS NOTES BY PATIENT",2,0,0)
 D MSG("FUNCTION:  Use to view one progress note for one patient.",2,0,0)
 D MSG(" CHOICES:  Progress Notes are listed, 5 at a time, in descending order for",1,0,0)
 D MSG($$SP(11)_"date range that you select.  Choose one from list to view.",1,0,0)
 Q
 ;
SPT ;EP; intro text for search by title and patient
 D ^XBCLS D MSG($$SP(20)_"SEARCH BY PATIENT AND TITLE",2,0,0)
 D MSG("FUNCTION:  Use to view all progress notes for one patient for selected titles.",2,0,0)
 D MSG(" CHOICES:  Select patient then title(s) to view and date range.",1,0,0)
 Q
 ;
VPN ;EP; intro text for iew progress notes across patients
 D ^XBCLS D MSG($$SP(15)_"VIEW PROGRESS NOTES ACROSS PATIENTS",2,0,0)
 D MSG("FUNCTION:  Use to review selected progress notes.",2,0,0)
 D MSG(" CHOICES:  Select Document Status (unsigned, completed, amended, etc.);",1,0,0)
 D MSG($$SP(11)_"then select Progress Note Category (by document class).",1,0,0)
 D MSG($$SP(11)_"then select Search Category (patient, author, service, title, etc.).",1,0,0)
 D MSG($$SP(11)_"At any selection prompt, you can choose ALL.",1,0,0)
 Q
 ;
PDD ;EP; intro text for print document definition
 D ^XBCLS D MSG($$SP(20)_"PRINT DOCUMENT DEFINITION",2,0,0)
 D MSG("FUNCTION:  Use to view setup for a document class or title",2,0,0)
 D MSG($$SP(11)_"and to view boilerplate attached to a title.",1,0,0)
 Q
 ;
PDL ;EP; intro text for print document list
 D ^XBCLS D MSG($$SP(20)_"PRINT DOCUMENT LIST",2,0,0)
 D MSG("FUNCTION:  Use to print or browse list of documents defined for your",2,0,0)
 D MSG($$SP(11)_"facility that are attached to the Clinical Document Class.",1,0,0)
 Q
 ;
PPR ;EP; intro text for personal preferences
 D ^XBCLS D MSG($$SP(20)_"PERSONAL PREFERENCES",2,0,0)
 D MSG("FUNCTION:  Use to customize software to individual user.",2,0,0)
 D MSG($$SP(11)_"Includes such things as viewing documents in ascending or",1,0,0)
 D MSG($$SP(11)_"descending order and customizing list of frequently used",1,0,0)
 D MSG($$SP(11)_"document titles.",1,2,0)
 Q
 ;
MSG(DATA,A1,A2,A3) ; -- calls write utility
 D MSG^BTIUU(DATA,A1,A2,A3) Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
