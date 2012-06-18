DGRPTP3 ;ALB/RMO - Print 10-10T Registration Cont.;10 JAN 1997 09:06 am
 ;;5.3;Registration;**108**;08/13/93
 ;
EN(DGLNE) ;Entry point to print 10-10T cont.
 ; Input  -- DGLNE    Line format array
 ; Output -- None
 ;
 ;Consent to release information
 W !,"Consent To Release Information: I hereby authorize the Department of Veterans Affairs to disclose any such history, diagnostic and"
 W !,"treatment information from my medical records (including information relating to the diagnosis, treatment or other therapy for the"
 W !,"conditions of drug abuse, alcoholism or alcohol abuse, sickle cell anemia, or testing for or infection with the human"
 W !,"immunodeficiency virus) to the carrier or contractor of any health plan contract under which I am apparently entitled to medical"
 W !,"care or payment of the expense of care that is identified above, as considered necessary by VA representatives for the discharge"
 W !,"of the legal or contractual obligations of the insurer or other party against whom liability is asserted.  I understand that I"
 W !,"may revoke this authorization at any time, except to the extent that action has already been taken in reliance on it.  Without my"
 W !,"express revocation, this consent will automatically expire when all action arising from VA's claim for reimbursement for my"
 W !,"medical care has been completed."
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;Co-payment notice
 W !,"Co-payment Notice: If your household income exceeds the established threshold, you will be considered ""Discretionary""."
 W !,"Such veterans must pay a co-payment not to exceed the Medicare deductible, plus a per diem for hospital and nursing care."
 W !,"By signing this application, you are agreeing to pay the VA the applicable co-payment if you are determined to be a"
 W !,"""discretionary"" veteran."
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;Signature block and date
 W !,"Signature of Applicant",?95,"|Date"
 W !?95,"|"
 W !?95,"|"
 W !,DGLNE("DD")
 ;
 ;Public reporting burden
 W !,"Public reporting burden for this collection of information is estimated to average 10 minutes per response, including the time for"
 W !,"reviewing instructions, searching existing data sources, gathering and maintaining the data needed, and completing and reviewing the"
 W !,"collection of information.  Send comments regarding this burden estimate or any other aspects of this collection, including"
 W !,"suggestions for reducing this burden to VA Clearance Officer (045A4), 810 Vermont Avenue, NW, Washington, DC 20420."
 W !,DGLNE("DD")
 ;
 ;Privacy act notice
 W !,"PRIVACY ACT NOTICE:  The information requested on this form is solicited under authority of Title 38, U.S.C., Sections 710, 1712"
 W !,"and 1722.  It is being collected to enable us to determine your eligibility for medical benefits, identify your medical records,"
 W !,"and provide basic data for your treatment.  Additional information, such as medical history, may be solicited during the course of"
 W !,"your medical evaluation or treatment.  The income and eligibility information you supply may be verified through a computer"
 W !,"matching program at any time and information may be disclosed outside VA as permitted by law; possible disclosures include"
 W !,"those described in the ""routine uses"" identified in the VA system of records 24VA136, Patient Medical Records-VA, published"
 W !,"in the Federal Register in accordance with the Privacy Act of 1974.  These ""routine uses"" include disclosures: in response"
 W !,"to court subpoenas; to epidemiological and other research facilities for research purposes; in connection with collections"
 W !,"of amounts owed to the United States; to the Department of Justice for use in litigation; to other Federal agencies in connection"
 W !,"with their employment determinations, investigations, or issuance of licenses or benefits; to report apparent law violations to"
 W !,"other Federal, State or local agencies charged with law enforcement responsibilities; in response to an official request from a"
 W !,"criminal or civil law enforcement governmental agency charged with the protection of public health or safety; to the Internal"
 W !,"Revenue Service to verify unearned income, collect amounts owed VA, and to report as income debts that are waived, compromised or"
 W !,"otherwise forgiven; to the Social Security Administration to verify earned income and employment data; to notify State licensing"
 W !,"boards and Federal agencies of the health care practices of health care providers; to non-VA health care providers; to non-VA"
 W !,"health care providers of facilities when the patient is referred for medical care at VA expense; to private sector organizations"
 W !,"for the purpose of obtaining accreditation or approval rating for the health care facility; to non-VA nursing homes for"
 W !,"preadmission screening; or, to contractors to perform the services covered by the contract.  Disclosure is voluntary, however,"
 W !,"failure to furnish the information will result in our inability to process your request and serve your medical needs."
 W !,"Failure to furnish the information will have no adverse effect on any other benefits to which you may be entitled."
 W !,"Disclosure of the Social Security number(s) of those for whom benefits are claimed is requested under the authority of"
 W !,"Title 38, U.S.C., and is voluntary.  Social Security numbers will be used in the administration of veteran's benefits,"
 W !,"in the identification of veterans or persons claiming or receiving VA benefits and their records and may be used for"
 W !,"other purposes where authorized by both Title 38, U.S.C., and the Privacy Act of 1974 (5 U.S.C. 552a) or where"
 W !,"required by another statute."
 Q
