ABMZWORK ; IHS/ADC/GTH - NEW PROGRAM ; [ 06/26/2001  5:43 PM ]
 ;;2.4; IHS 3P BILLING SYSTEM;**5**;June 11, 2001
 ; 
ENVOY ;
 ;
 ;  June 6, 2001
 ;  The RPMS DBA authorizes ABM a one-time inclusion of the following
 ;  subroutine in an ABM patch.  The subroutine removes SCREENS on
 ;  fields in the INSURER file which were placed there by AUT*98.1*8.
 ;  This one-time authorization is to eliminate inflicting another
 ;  patch on the field, and depends upon agreement by ABM to use it
 ;  only once, and review and certification by SRCT.
 ;
INSDD ;EP - Delete SCREENs from .51/.52/.53 nodes distributed in AUT*98.1*8.
 ;
 ;  There are no database calls to edit/delete fields in a dd.
 ;
 NEW AUT
 ;
 F AUT=.51,.52,.53 D
 .KILL ^DD(9999999.18,AUT,12),^(12.1)
 .S $P(^DD(9999999.18,AUT,0),"^",2)="P9002274.93'"
 .S $P(^DD(9999999.18,AUT,0),"^",4)="5;"_$E(AUT,3)
 .S $P(^DD(9999999.18,AUT,0),"^",5,99)="Q"
 .S ^DD(9999999.18,AUT,"DT")=DT
 ;
INSDDEND Q
