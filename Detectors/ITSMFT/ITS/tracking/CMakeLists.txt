o2_add_library(ITStracking
               TARGETVARNAME targetName
               SOURCES src/ClusterLines.cxx
                       src/Cluster.cxx
                       src/ROframe.cxx
                       src/IOUtils.cxx
                       src/Label.cxx
                       src/PrimaryVertexContext.cxx
                       src/Road.cxx
                       src/Tracker.cxx
                       src/TrackerTraitsCPU.cxx
                       src/ClusterLines.cxx
                       src/Vertexer.cxx
                       src/VertexerTraits.cxx
               PUBLIC_LINK_LIBRARIES O2::GPUCommon
                                     ms_gsl::ms_gsl
                                     O2::CommonConstants
                                     O2::DataFormatsITSMFT
                                     O2::SimulationDataFormat
                                     O2::ITSBase
                                     O2::DataFormatsITS)

o2_target_root_dictionary(ITStracking
                          HEADERS include/ITStracking/ClusterLines.h
                                  include/ITStracking/Tracklet.h
                          LINKDEF src/TrackingLinkDef.h)

if(CUDA_ENABLED)
  add_subdirectory(cuda)
  target_compile_definitions(${targetName} PRIVATE CUDA_ENABLED)
endif()
