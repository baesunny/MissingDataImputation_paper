
# 결측·NULL 셀을 강조해 엑셀에 기록한다.
write_excel <- function(data, file_path, sheet_name = "Sheet1",
                      null_color = "#FF6666", null_text_color = "#FFFFFF") {

  # 파일 존재 여부 확인
  if (file.exists(file_path)) {
    wb <- loadWorkbook(file_path)
  } else {
    wb <- createWorkbook()
  }

  addWorksheet(wb, sheet_name)

  # 데이터 쓰기
  writeData(wb, sheet_name, data, rowNames = FALSE, colNames = TRUE)

  # NULL 값 찾기 (더 포괄적으로)
  null_cells <- which(
    is.na(data) | 
    data == "" | 
    data == "NULL" | 
    data == "null" | 
    data == "NA" | 
    data == "na",
    arr.ind = TRUE
  )

  if (nrow(null_cells) > 0) {
    # 사용자 정의 스타일
    custom_style <- createStyle(
      bgFill = null_color,
      fontColour = null_text_color,
      border = "TopBottomLeftRight"#,
      #borderColour = "#FFFFFF"
    )
    
    # NULL 값 셀에 스타일 적용
    for (i in 1:nrow(null_cells)) {
      row_idx <- null_cells[i, 1] + 1
      col_idx <- null_cells[i, 2]
      
      addStyle(wb, sheet_name, custom_style, rows = row_idx, cols = col_idx)
    }
    
    cat(sheet_name, "의 NULL 값 셀", nrow(null_cells), "개를", null_color, "색으로 하이라이트했다.\n")
  } else {
    cat(sheet_name, "의 NULL 값이 발견되지 않았다.\n")
  }

  saveWorkbook(wb, file_path, overwrite = TRUE)
  cat("Excel 파일 저장 완료:", file_path, "\n")
}