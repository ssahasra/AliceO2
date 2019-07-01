o2_add_library(MIDClustering
               SOURCES src/Clusterizer.cxx src/PreClusterizer.cxx
                       src/PreCluster.cxx src/PreClusterHelper.cxx
                       src/PreClustersDE.cxx
               PUBLIC_LINK_LIBRARIES O2::MIDBase)
