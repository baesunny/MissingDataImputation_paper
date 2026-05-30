# ggplot2·로케일·OS별 한글 폰트를 설정한다.
korean_setting <- function() {
    # 1. ggplot2 패키지 확인 및 로드
    if (!require(ggplot2, quietly = TRUE)) {
       cat("ggplot2 패키지를 설치하고 로드합니다...\n")
       install.packages("ggplot2")
       library(ggplot2)
    } else {
        library(ggplot2)
    }


    # 2. 로케일 설정 (안전한 방식)
    tryCatch({
        # 시스템에서 사용 가능한 로케일 확인
        available_locales <- system("locale -a", intern = TRUE)
  
        if (any(grepl("ko_KR", available_locales))) {
            Sys.setlocale("LC_ALL", "ko_KR.UTF-8")
            cat("한국어 로케일 설정 완료: ko_KR.UTF-8\n")
        } else if (any(grepl("Korean", available_locales))) {
            Sys.setlocale("LC_ALL", "Korean")
            cat("한국어 로케일 설정 완료: Korean\n")
        } else {
            # 기본 로케일 사용
            Sys.setlocale("LC_ALL", "")
            cat("경고: 한국어 로케일을 찾을 수 없습니다. 기본 로케일을 사용합니다.\n")
        }
    }, error = function(e) {
        Sys.setlocale("LC_ALL", "")
        cat("경고: 로케일 설정 중 오류가 발생했습니다. 기본 로케일을 사용합니다.\n")
    })

    # 3. 인코딩 설정
    options(encoding = "UTF-8")

    # 4. 운영체제별 한글 폰트 설정 (개선된 버전)
    system_name <- Sys.info()["sysname"]

    if (system_name == "Windows") {
        # Windows 환경
        tryCatch({
            if (require(extrafont, quietly = TRUE)) {
                extrafont::loadfonts(device = "win")
                font_family <- "맑은 고딕"
            } else {
                windowsFonts(
                    malgun = windowsFont("맑은 고딕"),
                    nanum = windowsFont("나눔고딕")
                )
                font_family <- "malgun"
            }
    }, error = function(e) {
        font_family <- "sans"
        cat("경고: Windows 한글 폰트를 찾을 수 없습니다. 기본 폰트를 사용합니다.\n")
    })
  
    } else if (system_name == "Darwin") {
        # macOS 환경
        font_family <- "D2Coding"
  
    } else if (system_name == "Linux") {
        # Linux 환경
        Sys.setenv(LANG = "ko_KR.UTF-8")
        # Linux에서 사용 가능한 폰트 확인
        tryCatch({
            if (system("fc-list :lang=ko", intern = TRUE) != "") {
                font_family <- "NanumGothic"
            } else {
                font_family <- "DejaVu Sans"
            }
        }, error = function(e) {
            font_family <- "DejaVu Sans"
        })
  
    } else {
      # 기타 환경
        font_family <- "sans"
    }   


    # 5. ggplot2 테마 설정 (안전한 방식)
    tryCatch({
        # theme_set 함수가 사용 가능한지 확인
        if (exists("theme_set") && is.function(theme_set)) {
            theme_set(theme_minimal() + 
                theme(text = element_text(family = font_family)))
            cat("ggplot2 테마 설정 완료\n")
        } else {
            cat("경고: theme_set 함수를 찾을 수 없습니다.\n")
        }
    }, error = function(e) {
        cat("경고: ggplot2 테마 설정에 실패했습니다. 기본 테마를 사용합니다.\n")
        # 기본 테마만 설정
    tryCatch({
      if (exists("theme_set") && is.function(theme_set)) {
          theme_set(theme_minimal())
      }
    }, error = function(e2) {
        cat("경고: 기본 테마 설정도 실패했습니다.\n")
    })
    })

    # 6. 설정 확인 출력
    cat("\n=== 한글 출력 설정 확인 ===\n")
    cat("현재 로케일:", Sys.getlocale(), "\n")
    cat("사용 폰트:", font_family, "\n")
    cat("인코딩:", getOption("encoding"), "\n")
    cat("ggplot2 로드 상태:", "ggplot2" %in% loadedNamespaces(), "\n")
    cat("ggplot2 테마 설정 상태:", exists("theme_set") && is.function(theme_set), "\n")

    # 7. 세션 정보 출력
    cat("\n=== 세션 정보 ===\n")
    cat("현재 시간:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
    cat("R 버전:", R.version.string, "\n")
    # 세션 정보 출력
   print(sessionInfo())
 }