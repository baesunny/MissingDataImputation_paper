irkernel_setup  <- function(kernel_name, display_name) {
    # 1. IRkernel을 설치하고, Kernel 연결이 가능하도록 설정
    if (!require(IRkernel, quietly = TRUE)) {
      cat("IRkernel 패키지를 설치하고 로드합니다...\n")
      install.packages("IRkernel")
      library(IRkernel)
    } else {
      library(IRkernel)
    }

    IRkernel::installspec(user = TRUE)
    IRkernel::installspec(name = kernel_name, displayname = display_name)
}