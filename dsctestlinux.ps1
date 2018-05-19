Configuration dsctestlinux{

    Import-DscResource -ModuleName PSDesiredStateConfiguration,nx

    Node  "TestDSCLinuxfile"{
    nxFile ExampleFile {

        DestinationPath = "/tmp/example"
        Contents = "hello world `n"
        Ensure = "Present"
        Type = "File"
    }

    }

    Node "dscwebserver"{

        nxPackage apache2
    {
        Name = "apache2"
        Ensure = "Present"
        PackageManager = "apt"
    }

$IndexPage = @'
<html>
<head>
<title>My DSC Page</title>
</head>
<body>
<H1>Awesome DSC Test Page in the house!</H1>
</body>
</html>
'@

        nxFile index_html
    {
        DestinationPath = "/var/www/html/index.html"
        Type = "file"
        Contents = $IndexPage
        DependsOn = "[nxPackage]apache2"
    }

    nxService apache2service
    {
        Name = "apache2"
        State = "running"
        Enabled = $true
        Controller = "systemd"
        DependsOn = "[nxFile]index_html"
    }
}
}
