INSY184 ;slt;19 Aug 1994@090350;compiled gis system data
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
EN F I=1:2 S %ODD=$E($T(EN+I),4,999) Q:%ODD=""  S %EVEN=$E($T(EN+(I+1)),4,999) S X="^UTILITY(""INHSYS"","_$J_","_$P(%ODD,",",2,99),@X=%EVEN
 ;;^UTILITY(562037788,"SGF",208,0)
 ;;HL UNKNOWN^STRING^40
 ;;^UTILITY(562037788,"SGF",209,0)
 ;;HL MESSAGE TYPE^CODED ID^7
 ;;^UTILITY(562037788,"SGF",210,0)
 ;;HL MESSAGE CONTROL ID^STRING^20
 ;;^UTILITY(562037788,"SGF",211,0)
 ;;HL PROCESSING ID^CODED ID^1
 ;;^UTILITY(562037788,"SGF",212,0)
 ;;HL VERSION ID^NUMERIC^8
 ;;^UTILITY(562037788,"SGF",213,0)
 ;;HL SEQUENCE NUMBER^NUMERIC^15
 ;;^UTILITY(562037788,"SGF",214,0)
 ;;HL CONTINUATION POINTER^STRING^180
 ;;^UTILITY(562037788,"SGF",215,0)
 ;;HL ACCEPT ACK TYPE^CODED ID^2
 ;;^UTILITY(562037788,"SGF",215,1,0)
 ;;2^^2^2^2940208
 ;;^UTILITY(562037788,"SGF",215,1,1,0)
 ;;Defines the condiditions under which accept acknowledgements are required to
 ;;^UTILITY(562037788,"SGF",215,1,2,0)
 ;;returned in reponse to this message.
 ;;^UTILITY(562037788,"SGF",216,0)
 ;;HL APPLICATION ACK TYPE^CODED ID^2
 ;;^UTILITY(562037788,"SGF",216,1,0)
 ;;2^^2^2^2940208
 ;;^UTILITY(562037788,"SGF",216,1,1,0)
 ;;Defines the conditions under which applicaation acknowledgements are required
 ;;^UTILITY(562037788,"SGF",216,1,2,0)
 ;;to be returned in response to this message.
 ;;^UTILITY(562037788,"SGF",217,0)
 ;;HL COUNTRY CODE^CODED ID^2
 ;;^UTILITY(562037788,"SGF",217,1,0)
 ;;2^^2^2^2940208
 ;;^UTILITY(562037788,"SGF",217,1,1,0)
 ;;Defines the country of origin for the message.  It will be used primarily to
 ;;^UTILITY(562037788,"SGF",217,1,2,0)
 ;;specify default elements, such as currency denominations.
 ;;^UTILITY(562037788,"SGF",218,0)
 ;;HL ORDER CONTROL^CODED ID^2
 ;;^UTILITY(562037788,"SGF",218,1,0)
 ;;10^^10^10^2940217
 ;;^UTILITY(562037788,"SGF",218,1,1,0)
 ;;Determines the function of the order segment.  Trigger event identifier for
 ;;^UTILITY(562037788,"SGF",218,1,2,0)
 ;;orders.
 ;;^UTILITY(562037788,"SGF",218,1,3,0)
 ;;  
 ;;^UTILITY(562037788,"SGF",218,1,4,0)
 ;;      NW - NEW ORDER
 ;;^UTILITY(562037788,"SGF",218,1,5,0)
 ;;      CA - CANCEL ORDER
 ;;^UTILITY(562037788,"SGF",218,1,6,0)
 ;;      DC - DISCONTINUE ORDER
 ;;^UTILITY(562037788,"SGF",218,1,7,0)
 ;;      HD - HOLD ORDER
 ;;^UTILITY(562037788,"SGF",218,1,8,0)
 ;;      RL - RELEASE HOLD
 ;;^UTILITY(562037788,"SGF",218,1,9,0)
 ;;      RP - REPLACE ORDER (MODIFY)
 ;;^UTILITY(562037788,"SGF",218,1,10,0)
 ;;      RO - REPLACEMENT ORDER (MODIFY)
 ;;^UTILITY(562037788,"SGF",218,"C")
 ;;@OREVENT
 ;;^UTILITY(562037788,"SGF",222,0)
 ;;HL ORDER STATUS (ID)^CODED ID^2
 ;;^UTILITY(562037788,"SGF",222,1,0)
 ;;3^^3^3^2940215
 ;;^UTILITY(562037788,"SGF",222,1,1,0)
 ;;Status of an order.  This field is used to report the status of an order
 ;;^UTILITY(562037788,"SGF",222,1,2,0)
 ;;either upon request or when the status changes.  Only the filler application
 ;;^UTILITY(562037788,"SGF",222,1,3,0)
 ;;can originate the value of this field.
 ;;^UTILITY(562037788,"SGF",222,"C")
 ;;@ORSTAT
 ;;^UTILITY(562037788,"SGF",224,0)
 ;;HL QUANTITY/TIMING^COMPOSITE^200
 ;;^UTILITY(562037788,"SGF",224,1,0)
 ;;5^^5^5^2940215
 ;;^UTILITY(562037788,"SGF",224,1,1,0)
 ;;Components: Quantity^interval^duration^start date/time^End date/time^priority
 ;;^UTILITY(562037788,"SGF",224,1,2,0)
 ;;^condition^text^conjunction^order sequencing
 ;;^UTILITY(562037788,"SGF",224,1,3,0)
 ;;  
 ;;^UTILITY(562037788,"SGF",224,1,4,0)
 ;;Determines the priority, quantity, frequency, and timing of an atomic
 ;;^UTILITY(562037788,"SGF",224,1,5,0)
 ;;service.
 ;;^UTILITY(562037788,"SGF",224,"C")
 ;;@ORQT
 ;;^UTILITY(562037788,"SGF",226,0)
 ;;HL DT/TM OF TRANSACTION^TIME STAMP^26
 ;;^UTILITY(562037788,"SGF",226,1,0)
 ;;2^^2^2^2940215
 ;;^UTILITY(562037788,"SGF",226,1,1,0)
 ;;For new orders, this is the date/time the order was entered (101;1.22)
 ;;^UTILITY(562037788,"SGF",226,1,2,0)
 ;;For modified,cancelled,hold orders, etc it is the time of the status change.
 ;;^UTILITY(562037788,"SGF",226,"C")
 ;;@ORTT
 ;;^UTILITY(562037788,"SGF",227,0)
 ;;HL ENTERED BY^COMPOSITE PERSON NAME SPECIAL^80
 ;;^UTILITY(562037788,"SGF",227,1,0)
 ;;2^^2^2^2940215
 ;;^UTILITY(562037788,"SGF",227,1,1,0)
 ;;The user who entered the order (101;1.01) or the user who entered the status
 ;;^UTILITY(562037788,"SGF",227,1,2,0)
 ;;change (status change user signature).
 ;;^UTILITY(562037788,"SGF",227,"C")
 ;;@ORDUZ
 ;;^UTILITY(562037788,"SGF",228,0)
 ;;HL VERIFIED BY^COMPOSITE PERSON NAME SPECIAL^80
 ;;^UTILITY(562037788,"SGF",228,1,0)
 ;;2^^2^2^2940215
 ;;^UTILITY(562037788,"SGF",228,1,1,0)
 ;;The HCP signature field (101;1.05) for new orders or the Status change
 ;;^UTILITY(562037788,"SGF",228,1,2,0)
 ;;authorized by for modified, canceled,etc orders.
 ;;^UTILITY(562037788,"SGF",228,50)
 ;;PROVIDER
 ;;^UTILITY(562037788,"SGF",228,"C")
 ;;@ORHCP
 ;;^UTILITY(562037788,"SGF",233,0)
 ;;HL ORDER CODE REASON^STRING^200
 ;;^UTILITY(562037788,"SGF",233,1,0)
 ;;1^^1^1^2940215
 ;;^UTILITY(562037788,"SGF",233,1,1,0)
 ;;Cancel/Modify reason.
 ;;^UTILITY(562037788,"SGF",233,"C")
 ;;@ORCOM
 ;;^UTILITY(562037788,"SGF",234,0)
 ;;HL SET ID - OBR REQ^SET ID^4
 ;;^UTILITY(562037788,"SGF",234,1,0)
 ;;^^1^1^2940215
 ;;^UTILITY(562037788,"SGF",234,1,1,0)
 ;;Sequential number to indicate number of orders being transmitted in message.
 ;;^UTILITY(562037788,"SGF",234,"C")
 ;;"OBR"
 ;;^UTILITY(562037788,"SGF",238,0)
 ;;HL OBSERVATION DT/TM^TIME STAMP^26
 ;;^UTILITY(562037788,"SGF",238,1,0)
 ;;1^^1^1^2940216
 ;;^UTILITY(562037788,"SGF",238,1,1,0)
 ;;Collection date/time for lab orders, Exam date/time for Rad Orders
 ;;^UTILITY(562037788,"SGF",238,"C")
 ;;@OBSDATE
 ;;^UTILITY(562037788,"SGF",245,0)
 ;;HL SPECIMEN REC'D DT/TM^TIME STAMP^26
 ;;^UTILITY(562037788,"SGF",245,1,0)
 ;;1^^1^1^2940216
 ;;^UTILITY(562037788,"SGF",245,1,1,0)
 ;;Log-in date/time for lab orders.  Arrival date/time for Rad orders.
 ;;^UTILITY(562037788,"SGF",245,"C")
 ;;@RECDATE
 ;;^UTILITY(562037788,"SGF",253,0)
 ;;HL RESULTS REPORT DT/TM^TIME STAMP^26
 ;;^UTILITY(562037788,"SGF",253,1,0)
 ;;3^^3^3^2940216
 Q
