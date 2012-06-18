XMZDOM3 ;(WASH ISC)/CAP - CONVERT MAILMAN HOST #'S TO IDCU ;5/21/90  13:35
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;1.0;
IDCU W !!,*7,"You MUST have these codes for the MINIENGINE and AUSTIN entries in the",!,"TRANSMISSION SCRIPT file (4.6) to work.  Enter them later (but before you",!,"try to turn on your network mail -- it won't work without them."
 W !!,"The place to enter them is clearly marked with dummy codes in the TEXT field",!,"of both the MINIENGINE and AUSTIN entries in the TRANSMISSION SCRIPT file",!,"if you didn't enter anything.  If you entered the wrong code, the wrong code"
 W !,"will be entered there instead."
 W !!,"Line 3 of the TEXT field will begin with ""S "".  Following this will",!,"be either ""UserID"" or what you typed in incorectly."
 W !!,"Line 5 of the TEXT field will begin with ""S "".  Following this will",!,"be either ""Password"" or what you typed in incorrectly."
 W !!,*7,"If you decide to continue, use FileMan to EDIT the MINIENGINE and AUSTIN",!,"entries in the TRANSMISSION SCRIPT file when this process completes.",!,"Enter the correct values for the 'UserID' and 'Password'."
 W !!,"To ABORT and RETRY LATER enter ""^"": "
 S X="" R X:600 E  S X="^" Q
