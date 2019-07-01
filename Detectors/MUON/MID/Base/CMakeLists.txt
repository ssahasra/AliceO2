o2_add_library(MIDBase
               SOURCES src/ChamberEfficiency.cxx src/Constants.cxx
                       src/GeometryTransformer.cxx src/Mapping.cxx
                       src/MpArea.cxx
               PUBLIC_LINK_LIBRARIES O2::MathUtils O2::DataFormatsMID)
