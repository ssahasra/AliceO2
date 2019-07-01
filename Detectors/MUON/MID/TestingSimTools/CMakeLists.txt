o2_add_library(MIDTestingSimTools
               SOURCES src/TrackGenerator.cxx src/HitFinder.cxx
               PUBLIC_LINK_LIBRARIES O2::MIDBase O2::DataFormatsMID)
