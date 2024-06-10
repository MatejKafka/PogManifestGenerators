@{
    ListVersions = {
        Invoke-WebRequest "https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads" `
            | % Links `
            | ? href -match "^(/-/media/Files/downloads/gnu/([^/]*)/binrel/arm-gnu-toolchain-.*-mingw-w64-i686-arm-none-eabi\.zip)\?" -ErrorAction Ignore `
            | % {
                @{
                    Version = $Matches[2]
                    Url = "https://developer.arm.com" + $Matches[1]
                }
            }

        @{Version = "11.2-2022.02"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-mingw-w64-i686-arm-none-eabi.zip"}
        # older versions, available from `https://developer.arm.com/downloads/-/gnu-a`, with pretty wild format
        @{Version = "10.3-2021.07"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-mingw-w64-i686-arm-none-eabi.tar.xz"}
        @{Version = "10.2-2020.11"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-mingw-w64-i686-arm-none-eabi.tar.xz"}
        @{Version =  "9.2-2019.12"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-mingw-w64-i686-arm-none-eabi.tar.xz"}
        @{Version =  "8.3-2019.03"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-i686-mingw32-arm-eabi.tar.xz"}
        @{Version =  "8.3-2019.02"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.02/gcc-arm-8.3-2019.02-i686-mingw32-arm-eabi.tar.xz"}
        @{Version =  "8.2-2019.01"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2019.01/gcc-arm-8.2-2019.01-i686-mingw32-arm-eabi.tar.xz"}
        @{Version =  "8.2-2018.11"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.11/gcc-arm-8.2-2018.11-i686-mingw32-arm-eabi.tar.xz"}
        @{Version =  "8.2-2018.08"; Url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/gcc-arm-8.2-2018.08-i686-mingw32-arm-eabi.tar.xz"}
    }

    Generate = {
        [ordered]@{
            Version = $_.Version
            Url = $_.Url
            # FIXME: the archives are pretty large (~300MB), this is slow
            Hash = Get-UrlHash $_.Url
        }
    }
}