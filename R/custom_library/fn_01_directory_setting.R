# 분석용 작업·결과·스탬프 디렉터리를 생성하고 경로 설정 파일을 기록한다.
directory_setting <- function(SRC_FILE_NAME = SELECTED_FILE, CUR_DIR = current_dir, T_stamp = WORK_DATE, Data_stamp = WORK_TIME, SET_FILE = SETTING_FILE) {
  analysis_stamp <- paste0("results/analysis_", T_stamp, sep="")
  # 상대경로로 디렉토리 설정
  WORK_DIR <- file.path(CUR_DIR, "sources")
  RSLT_DIR <- file.path(CUR_DIR, "results")
  ANAL_DIR <- file.path(CUR_DIR, analysis_stamp)

  # 디렉토리가 존재하지 않으면 생성
  if (!dir.exists(WORK_DIR)) {
    dir.create(WORK_DIR, recursive = TRUE)  
  }

  if (!dir.exists(RSLT_DIR)) {
    dir.create(RSLT_DIR, recursive = TRUE)  
  }

  if (!dir.exists(ANAL_DIR)) {
    dir.create(ANAL_DIR, recursive = TRUE)  
  }

  # 분석 대상 파일 경로 및 파일 설정
  SRC_FILE <- paste(WORK_DIR, "/", SRC_FILE_NAME, ".xlsx", sep="")

  # 분석결과 정리 파일 지정
  EXCEL_FILE <- file.path(ANAL_DIR, paste0("SourceData", Data_stamp, ".xlsx"))
  PDF_FILE   <- file.path(ANAL_DIR, paste0("SourceData", Data_stamp, ".xlsx"))

  # 디렉토리 설정 파일 생성
  dirsetting_file <- file.path(CUR_DIR, SET_FILE)
  if (file.exists(dirsetting_file)) {
    file.remove(dirsetting_file)
  }


  # "dirsetting.dat" 파일이 이미 존재하면 삭제 후 새로 생성
  dirsetting_file <- file.path(current_dir, SET_FILE)

  if (file.exists(dirsetting_file)) {
    file.remove(dirsetting_file)
  }

  # 각 변수 값을 차례대로 벡터에 저장
  dirsetting_contents <- c(
    WORK_DIR,
    RSLT_DIR,
    ANAL_DIR,
    SRC_FILE,
    EXCEL_FILE,
    PDF_FILE
  )

  # 파일에 기록
  writeLines(dirsetting_contents, dirsetting_file)

  cat("현재 작업 경로:    ", CUR_DIR, "\n\n")
  cat("1열 - 분석 대상 파일경로:", WORK_DIR, "\n")
  cat("2열 - 분석 결과 파일경로:", RSLT_DIR, "\n")

  cat("3열 - 분석 진행 파일경로:", ANAL_DIR, "\n\n")

  cat("4열 - 분석 대상 파일    :", SRC_FILE, "\n")
  cat("5열 - 분석 진행 엑셀파일:", EXCEL_FILE, "\n")
  cat("6열 - 분석 진행 PDF 파일:", PDF_FILE, "\n")

  cat("dirsetting.txt 파일이 생성되었습니다: ", dirsetting_file, "\n")
}