DG53244R ;BPOIFO/KEITH - Post-init continuation for DG*5.3*244 ; 27 Jan 2002  6:45 PM
 ;;5.3;Registration;**244**;Aug 13, 1993
 ;
ITXDES ;Set input transforms and field descriptions
 D BMES^XPDUTL("Setting field descriptions and input transforms")
 S $P(^DD(2,.01,0),U,5,99)="K:$L(X)>30!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,30) K:'$L(X) X,DG20NAME S:$D(X) DGNEWVAL=X"
 S ^DD(2,.01,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-30 characters in length."
 K ^DD(2,.01,21)
 S ^DD(2,.01,21,0)="^^4^4^2990208^^^^"
 S ^DD(2,.01,21,1,0)="Enter the patient's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.01,21,2,0)="This value must be 3-30 characters in length and may contain only uppercase"
 S ^DD(2,.01,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.01,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.211,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME"
 S ^DD(2,.211,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.211,21)
 S ^DD(2,.211,21,0)="^^4^4^2861007^"
 S ^DD(2,.211,21,1,0)="Enter the primary next of kin's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.211,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.211,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.211,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.2191,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME I $D(X) D K1^DGLOCK2"
 S ^DD(2,.2191,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.2191,21)
 S ^DD(2,.2191,21,0)="^^4^4^2861007^^"
 S ^DD(2,.2191,21,1,0)="Enter the secondary next of kin's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.2191,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.2191,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.2191,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.2401,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME"
 S ^DD(2,.2401,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.2401,21)
 S ^DD(2,.2401,21,0)="^^4^4^2861007^"
 S ^DD(2,.2401,21,1,0)="Enter the father's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.2401,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.2401,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.2401,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.2402,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME"
 S ^DD(2,.2402,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.2402,21)
 S ^DD(2,.2402,21,0)="^^4^4^2861007^"
 S ^DD(2,.2402,21,1,0)="Enter the mother's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.2402,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.2402,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.2402,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.2403,0),U,5,99)="K:$L(X)>35!($L(X)<2) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35,,2,,1) K:'$L(X) X,DG20NAME"
 S ^DD(2,.2403,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.2403,21)
 S ^DD(2,.2403,21,0)="^^4^4^2861007^"
 S ^DD(2,.2403,21,1,0)="Enter the mother's maiden name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.2403,21,2,0)="Entry of the LAST name only is permitted and the comma may be omitted."
 S ^DD(2,.2403,21,3,0)="If the response contains no comma, one will be appended to the value."
 S ^DD(2,.2403,21,4,0)="Including the comma, the value must be at least 3 characters in length."
 S $P(^DD(2,.331,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME"
 S ^DD(2,.331,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.331,21)
 S ^DD(2,.331,21,0)="^^4^4^2861117^^^"
 S ^DD(2,.331,21,1,0)="Enter the primary emergency contact's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.331,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.331,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.331,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.3311,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME I $D(X) D E1^DGLOCK2"
 S ^DD(2,.3311,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.3311,21)
 S ^DD(2,.3311,21,0)="^^4^4^2861007^"
 S ^DD(2,.3311,21,1,0)="Enter the secondary emergency contact's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.3311,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.3311,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.3311,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2,.341,0),U,5,99)="K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35) K:'$L(X) X,DG20NAME"
 S ^DD(2,.341,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-35 characters in length."
 K ^DD(2,.341,21)
 S ^DD(2,.341,21,0)="^^4^4^2861007^"
 S ^DD(2,.341,21,1,0)="Enter the designee's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2,.341,21,2,0)="This value must be 3-35 characters in length and may contain only uppercase"
 S ^DD(2,.341,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2,.341,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2.01,.01,0),U,5,99)="K:$L(X)>30!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,30) K:'$L(X) X,DG20NAME"
 S ^DD(2.01,.01,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-30 characters in length."
 K ^DD(2.01,.01,21)
 S ^DD(2.01,.01,21,0)="^^4^4^2861007^"
 S ^DD(2.01,.01,21,1,0)="Enter the alias name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2.01,.01,21,2,0)="This value must be 3-30 characters in length and may contain only uppercase"
 S ^DD(2.01,.01,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2.01,.01,21,4,0)="characters and parenthetical text will be removed."
 S $P(^DD(2.101,30,0),U,5,99)="K:$L(X)>30!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,30) K:'$L(X) X,DG20NAME"
 S ^DD(2.101,30,3)="Enter name in 'LAST,FIRST MIDDLE SUFFIX' format, must be 3-30 characters in length."
 K ^DD(2.101,30,21)
 S ^DD(2.101,30,21,0)="^^4^4^2911214^^"
 S ^DD(2.101,30,21,1,0)="Enter the attorney's name in 'LAST,FIRST MIDDLE SUFFIX' format."
 S ^DD(2.101,30,21,2,0)="This value must be 3-30 characters in length and may contain only uppercase"
 S ^DD(2.101,30,21,3,0)="alpha characters, spaces, apostrophes, hyphens and one comma.  All other"
 S ^DD(2.101,30,21,4,0)="characters and parenthetical text will be removed."
 Q
 ;
DES(DGI,DGA,DGF) ;Set up long description array
 ;Input: DGI=index number
 ;       DGA=array (pass by reference)
 ;       DGF=field number
 K DGA
 I DGI=72 D  Q
 .S DGA(1)="This cross reference facilitates PATIENT file lookups by a standardized name"
 .S DGA(2)="value.  In addition to the standardization applied by Kernel name utilities,"
 .S DGA(3)="hyphens and apostrophies are also removed from the name value.  This cross"
 .S DGA(4)="reference is only set if the standardized name is different than the patient"
 .S DGA(5)="name value stored in the NAME (#.01) field."
 S DGA(1)="This cross reference uses Kernel name standardization APIs to keep the NAME"
 S DGA(2)="COMPONENTS (#20) file record associated with the #"_DGF_" field synchronized"
 S DGA(3)="with the data value stored in that field."
 Q
