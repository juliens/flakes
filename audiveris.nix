{ lib
, stdenv
, fetchFromGitHub
, jdk17
, makeWrapper
, unzip
}:

stdenv.mkDerivation rec {
  pname = "audiveris";
  version = "5.6.3";
  
  src = fetchFromGitHub {
    owner = "Audiveris";
    repo = "audiveris";
    rev = "${version}";
    sha256 = "sha256-scYCDrG6GjfZt34STSGzUplDFAwiGR/aoH9VyHSBbas="; # Placeholder hash
  };

  nativeBuildInputs = [
    jdk17
    makeWrapper
    unzip
  ];

  buildInputs = [
    jdk17
  ];

  JAVA_HOME = "${jdk17}/lib/openjdk";

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src
    cd */
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    echo "Audiveris requires pre-built JAR or manual gradle build"
    echo "This is a placeholder build - check releases for pre-built JAR"
    mkdir -p build/libs
    # Create a dummy JAR for now
    echo "Manifest-Version: 1.0" > MANIFEST.MF
    ${jdk17}/bin/jar cfm build/libs/audiveris-${version}.jar MANIFEST.MF
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/lib $out/bin
    
    # Copy built JAR
    cp build/libs/*.jar $out/lib/
    
    # Create launch script
    cat > $out/bin/audiveris << EOF
#!/bin/sh
exec ${jdk17}/bin/java -jar $out/lib/audiveris-*.jar "\$@"
EOF
    chmod +x $out/bin/audiveris
    
    runHook postInstall
  '';


  meta = with lib; {
    description = "Optical Music Recognition (OMR) software";
    longDescription = ''
      Audiveris is an Optical Music Recognition (OMR) application 
      that processes digital images of music scores and produces 
      corresponding symbolic music information.
      
      NOTE: This is a simplified build that creates a placeholder.
      For a working version, download pre-built JAR from releases.
    '';
    homepage = "https://github.com/Audiveris/audiveris";
    license = licenses.agpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
    broken = true; # Marked as broken - needs proper gradle build setup
  };
}
