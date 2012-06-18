INCRYPT ; cmi/flag/maw - DGH 3 May 99 11:09 Interface encryption calls ;
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_450; GEN 18; 26-SEP-1996
 ;COPYRIGHT 1991, 1992 SAIC
 ;
 ;This routine contains the M tags which call out to the
 ;encryption functions written in C. The syntax is tested
 ;for DSM running on VMS. If platform specific routines are
 ;required, a copy of this routine should be placed in
 ;INCRYPVX = V
 ;INCRYPMS = MSM version
 ;etc.
 ;
ENCRYPT(XIN,XOUT,LEN,START,END) ;Call to C encryption function
 ;INPUT:
 ; XIN = String to be encrypted
 ; XOUT = PBR variable which the encryption function will return
 ;        as the encrypted string
 ; LEN = $Length of the original string
 ; START = 1 if this is the first string of a message to be encrypted.
 ; END = 1 if this is the last string of a message to be encrypted.
 ;S OLEN=$&DES.OUTCBC(.XIN,.XOUT,LEN,START,END)
 Q
 ;
DECRYPT(XCRYPT,XDE,LEN,START,END) ;Call to C decryption functions
 ;INPUT:
 ; XCRYPT = Incoming encrypted string to be decrypted
 ; XDE = PBR variable which the decryption function will return as
 ;       the decrypted string.
 ; LEN = $Length of the incoming encrypted string
 ; START = 1 if this is the first string of a message to be dencrypted.
 ; END = 1 if this is the last string of a message to be dencrypted.
 ;S OLEN=$&DES.INCBC(.XCRYPT,.XDE,LEN,START,END)
 Q
 ;
CRYPON(DESKEY) ;Starts the C encryption/decryption background job
 ;Quits with a 1. No current logic for failure
 ;S RC=$&DES.SKEY(.DESKEY)
 Q 1
 ;
CRYPOFF() ;Stops the C encryption/decryption background job
 ;Quits with a 1. No current logic for failure
 ;S RC=$&DES.DONE()
 Q 1
 ;
