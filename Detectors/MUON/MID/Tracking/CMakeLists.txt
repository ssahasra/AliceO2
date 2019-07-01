o2_add_library(MIDTracking
               SOURCES src/Tracker.cxx
               PUBLIC_LINK_LIBRARIES O2::DataFormatsMID O2::MIDBase
                                     O2::MIDTestingSimTools)
