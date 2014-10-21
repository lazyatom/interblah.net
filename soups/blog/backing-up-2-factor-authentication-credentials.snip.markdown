Backing Up 2-Factor Authentication Credentials
==============================================

My ex-colleagues at Free Range wrote about [sharing 2-factor authentication (2FA) credentials][gfr-blog] yesterday, which reminded me of a little trick that I like to use when setting up 2FA with a mobile authenticator: **don't use the QR code**.

What?!
-----

Certainly, the QR code is convenient, but it's also opaque and if you just scan it and move on with the setup, you'll never see it again

This bit me when I had my phone replaced earlier this year, only two find that my authenticator app hadn't stored any backup of the credentials it needed to generate tokens[^encrypted-backup]. I tried to log in to one of my newly-secured 2FA services (Gandi, in this case), only to find myself unable to generate the security code, and without any way to log in, no way to re-add the credentials to the authenticator app on the phone!

In this specific case I managed to get back in by calling the service and verifying my identity over the phone, but it's hassle that I'd rather not repeat.

So, to avoid this, here's what I do now.

Get the secret key
------------------

Instead of scanning the QR code, ask for the secret key:

![](/images/2fa-key.png)

Take a note of this somewhere (I store it in [1Password], for example). Now if you ever need to somehow re-add this service to your authenticator application, you can use this code.

Once you have the code, you're free to switch back to the QR code (which contains exactly the same information) for a more convenient way of getting that data into your app.


2FA using the command-line
----------

One secondary benefit of having the code available is that you don't need to pull out your phone to generate an authentication code. Using a program called `oathtool`, you can generate codes in the Terminal:

    $ oathtool --base32 --totp "YOURCODEHERESOSECRETSOSAFEYESSSS"
    => 529038

You can even get the code ready to paste straight into the web form:

    $ oathtool --base32 --totp "YOURCODE..." | pbcopy

Now you can simply switch back to the webpage and paste the code using a single keystroke. Boom.


Sharing 2FA with colleagues
----------

Another benefit of storing the code is that you can give other people access to the same credentials without everyone needing to be present when the QR code is on the screen (which might not even be possible if they are remote).

Instead, you just need to (securely) share the code with them, and they can  add it to their authenticator app and start accessing the 2FA-secured service. Admittedly, this is more cumbersome than scanning a convenient QR code

... which is why [the post on the Free Range blog][gfr-blog] prompted me to write this :)


[^encrypted-backup]: This may have been because I didn't encrypt the backup for my phone in iTunes, which means (I believe) that no passwords will be saved, but it could also be a legitimate security measure by the app itself.

[gfr-blog]: (http://gofreerange.com/two-factor-authentication-with-multiple-devices)

:kind: blog
:created_at: 2014-10-21 14:05:58 +0100
:updated_at: 2014-10-21 14:05:58 +0100
