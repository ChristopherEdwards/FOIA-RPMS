AUPNLKH ; IHS/CMI/LAB - HELP PROMPTS ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
HELP ;
 I AUPX["??" S DZ="??",D="B",X=AUPX D DQ^DICQ S AUPQF=3 Q
 D EN^DDIOL("Identify the Patient in one of the following ways:","","!!")
 D EN^DDIOL("- Enter the Patient's NAME or a portion of the NAME in the following format: ","","!"),EN^DDIOL("HORSECHIEF,JOHN DOE  or HORSECHIEF,JOHN","","!?10")
 D EN^DDIOL("1...Use from 3 to 30 letters","","!!?5"),EN^DDIOL("2...a COMMA MUST FOLLOW THE LAST NAME","","!?5"),EN^DDIOL("3...If ""JR"" or ""II"", etc, is included, follow the form SMITH,JOHN MARK,JR.","","!?5")
 D EN^DDIOL("4...NO SPACES after commas.","","!?5")
 D EN^DDIOL("- Enter the Patient's IHS Chart Number","","!!")
 D EN^DDIOL("- Enter the Patient's DOB in one of the following forms: ","","!!"),EN^DDIOL("B012266 or any valid date e.g.  01/22/66, 01-22-66, JAN 22,1966","","!?5")
 D EN^DDIOL("- Enter the Patient's SSN or the last 4 digits of the SSN","","!!")
 D EN^DDIOL("- If the Patient is an Inpatient enter the Ward or Room-Bed in the form:","","!!"),EN^DDIOL("66-2   PEDIATRICS","","!?5")
 Q
