let
  secrets = import ./secrets.nix;
in
{
  asterisk.extensions_conf = ''
    [general]
    static=yes
    writeprotect=no
    clearglobalvars=no
    [globals]
    CONSOLE=Console/dsp
    IAXINFO=guest
    TRUNK=DAHDI/G2
    TRUNKMSD=1

    [default]
    exten => 5555533626,1,Dial(PJSIP/33626, 30)
    exten => 5555566666,1,Dial(PJSIP/33666, 30)
    include => voipms-inbound
    include => voipms-outbound

    exten => 33621,1,Dial(PJSIP/33621, 30)
    exten => 33622,1,Dial(PJSIP/33622, 30)
    exten => 33623,1,Dial(PJSIP/ata-client3, 30)
    exten => 33624,1,Dial(PJSIP/ata-client4, 30)
    exten => 33625,1,Dial(PJSIP/33625, 30)
    exten => 33626,1,Dial(PJSIP/33626, 30)
    exten => 33666,1,Playback(/srv/media/ghost/ghost''${RAND(1,38)})

    [voipms-outbound]
    exten => _1NXXNXXXXXX,1,Set(CALLERID(NUM)=${secrets.asterisk.did_number})
            same => n,Dial(PJSIP/''${EXTEN}@voipms)
            same => ,n,Hangup()
    exten => _NXXNXXXXXX,1,Set(CALLERID(NUM)=${secrets.asterisk.did_number})
            same => n,Dial(PJSIP/1''${EXTEN}@voipms)
            same => n,Hangup()
    exten => _011.,1,Set(CALLERID(NUM)=${secrets.asterisk.did_number})
            same => n,Dial(PJSIP/''${EXTEN}@voipms)
            same => n,Hangup()
    exten => _00.,1,Set(CALLERID(NUM)=${secrets.asterisk.did_number})
            same => n,Dial(PJSIP/''${EXTEN}@voipms)
            same => n,Hangup()
    ;exten => _1NXXNXXXXXX,1,Dial(PJSIP/''${EXTEN}@voipms)
    ;exten => _1NXXNXXXXXX,n,Hangup()
    ;exten => _NXXNXXXXXX,1,Dial(PJSIP/1''${EXTEN}@voipms)
    ;exten => _NXXNXXXXXX,n,Hangup()
    ;exten => _011.,1,Dial(PJSIP/''${EXTEN}@voipms)
    ;exten => _011.,n,Hangup()
    ;exten => _00.,1,Dial(PJSIP/''${EXTEN}@voipms)
    ;exten => _00.,n,Hangup()


    [voipms-inbound]
    exten => ${secrets.asterisk.did_number},1,Dial(PJSIP/33622&PJSIP/ata-client3&PJSIP/ata-client4&PJSIP/33625&PJSIP/33626, 30)
  '';

  asterisk.pjsip_conf = ''
    [transport-udp]
    type=transport
    protocol=udp
    bind=0.0.0.0
  
    [voipms]
    type=registration
    transport=transport-udp
    outbound_auth=voipms
    client_uri=sip:${secrets.asterisk.sip_user}@${secrets.asterisk.sip_server}:5060
    server_uri=sip:${secrets.asterisk.sip_server}:5060

    [voipms]
    type=auth 
    auth_type=userpass
    username=${secrets.asterisk.sip_user}
    password=${secrets.asterisk.sip_pass}

    [voipms]
    type=aor
    contact=sip:${secrets.asterisk.sip_user}@${secrets.asterisk.sip_server}
    qualify_frequency=60
    qualify_timeout=6.0

    [voipms]
    type=endpoint
    transport=transport-udp
    context=default
    disallow=all
    allow=ulaw
    from_user=${secrets.asterisk.sip_user}
    auth=voipms
    outbound_auth=voipms
    aors=voipms
    rtp_symmetric=yes
    rewrite_contact=yes
    send_rpid=yes
    identify_by=ip

    [voipms]
    type=identify
    endpoint=voipms
    match=${secrets.asterisk.sip_server}

    [33621]
    type=endpoint
    context=default
    disallow=all
    allow=ulaw
    auth=33621-auth
    aors=33621

    [33621-auth]
    type=auth
    auth_type=userpass
    username=33621
    password=password

    [33621]
    type=aor
    max_contacts=1

    [33622]
    type=endpoint
    context=default
    disallow=all
    allow=ulaw
    auth=33622-auth
    aors=33622

    [33622-auth]
    type=auth
    auth_type=userpass
    username=33622
    password=password

    [33622]
    type=aor
    max_contacts=1

    [ata-client3]
    type=endpoint
    context=default
    disallow=all
    allow=ulaw
    auth=ata-client3-auth
    aors=ata-client3

    [ata-client3-auth]
    type=auth
    auth_type=userpass
    username=ata-client3
    password=password

    [ata-client3]
    type=aor
    max_contacts=1

    [ata-client4]
    type=endpoint
    context=default
    disallow=all
    allow=ulaw
    auth=ata-client4-auth
    aors=ata-client4

    [ata-client4-auth]
    type=auth
    auth_type=userpass
    username=ata-client4
    password=password

    [ata-client4]
    type=aor
    max_contacts=1

    [33625]
    type=endpoint
    context=default
    disallow=all
    allow=ulaw
    auth=33625-auth
    aors=33625

    [33625-auth]
    type=auth
    auth_type=userpass
    username=33625
    password=password

    [33625]
    type=aor
    max_contacts=1

    [33626]
    type=endpoint
    context=default
    disallow=all
    allow=ulaw
    auth=33626-auth
    aors=33626
    force_rport=no
    rewrite_contact=no

    [33626-auth]
    type=auth
    auth_type=userpass
    username=33626
    password=password

    [33626]
    type=aor
    max_contacts=1
  '';
  asterisk.logger_conf = ''
    [general]
    [logfiles]
    console => notice,warning,error
    messages => notice,warning,error
  '';
}
