AGSSLETR ; IHS/ASDS/EFG - push/pull SSN form letter ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
PUT ;put text into file
 D DT^DICRW
 S AGSITE=$P(^AUTTSITE(1,0),U)
 I '$D(^AGFAC(AGSITE)) W !!,"No SITE ... Exiting",*7,!! H 3 Q
 I $D(^AGFAC(AGSITE,1)) W !,"Letter already present .. not re-installed",! Q  ;---^
 F AGI=1:1 S X=$T(TEXT+AGI),X=$P(X,";;",2,99) Q:X["END OF TEXT"  D
 .S ^AGFAC(AGSITE,1,AGI,0)=X
 .W "."
 S AGI=AGI-1,^AGFAC(AGSITE,1,0)="^^"_AGI_"^"_AGI_"^"_DT_"^^^^"
 K AGI,AGX,AGSITE
 Q
TEXT ;TEXT TO FOLLOW
 ;;|TODAY|
 ;; 
 ;; 
 ;;                         DRAFT
 ;;                         DRAFT
 ;; 
 ;;The Indian Health Service (IHS) is working to improve the
 ;;quality of its hardcopy and automated medical records. An
 ;;important element of the medical record is the Social Security
 ;;Number (SSN). SSNs Help IHS to more quickly and accurately find
 ;;specific medical records and to unduplicate medical records. 
 ;;The result is better patient care since an SSN allows IHS and
 ;;tribal contract employees to keep a better record of a) a
 ;;patient's health history, b) what medicines a patient has taken
 ;;and should take, c) what health treatment a patient was given
 ;;and should get, d) patient allergies (if any) and e) follow-up
 ;;care if needed. A SSN also allows tribal contractors to more
 ;;effectively bill third parties ( e.g., insurance companies,
 ;;Medicare, and Medicaid) for care provided to patients with such
 ;;coverage.
 ;; 
 ;;In order to ensure that it has complete and accurate SSNs on
 ;;file, IHS uses information that is available from other
 ;;government organizations. The Social Security Administration
 ;;and Medicaid are IHS' principal sources of SSN information. The
 ;;SSN listed below was provided to IHS. We believe it is your SSN
 ;;since the name, date of birth, and sex associated with the SSN
 ;;match the information you provided to us.
 ;; 
 ;;Please review the SSN that is listed below and let us know if
 ;;it is incorrect. Thank you for helping IHS do a better job for
 ;;you.
 ;; 
 ;; 
 ;;                                 Sincerely,
 ;; 
 ;; 
 ;; 
 ;;                                 George Washington
 ;;                                 
 ;;                                 
 ;;                                 
 ;;                                 
 ;;                                 
 ;;END OF TEXT
