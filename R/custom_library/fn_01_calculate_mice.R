# MICE 결과를 단일 세트·중앙값·최빈값·평균·전체 세트 중 하나로 반환한다.
# 필요한 라이브러리 설치 및 로드
if (!require(mice, quietly = TRUE)) {
  install.packages("mice")
}

library(mice)

calculate_mice <- function(mice_result, result_type = 1, set_number = 1) {
# result_type: 1 = 단일 세트, 2 = 중앙값, 3 = 최빈값, 4 = 평균값, 5= 전체 활용
  # 방법 1: 단일 대치 세트 (빠른 분석용)
  if (result_type == 1) {
    return(complete(mice_result, set_number))
  # 방법 2: 중앙값
  } else if (result_type == 2) {
    result <- mice_result$data
    for(col in names(result)) {
      if(is.numeric(result[[col]]) && col %in% names(mice_result$imp)) {
        imputed_values <- mice_result$imp[[col]]
        missing_indices <- which(is.na(result[[col]]))
          if(length(missing_indices) > 0) {
            result[[col]][missing_indices] <- apply(imputed_values, 1, median)
          }
      }
    }
    return(result)
  # 방법 3: 최빈값
  } else if (result_type == 3) {
     result <- mice_result$data
  
    for(col in names(result)) {
      if(col %in% names(mice_result$imp)) {
        imputed_values <- mice_result$imp[[col]]
        missing_indices <- which(is.na(result[[col]]))
        if(length(missing_indices) > 0) {
          # 각 행에 대해 최빈값 계산
          for(i in seq_along(missing_indices)) {
            row_values <- imputed_values[i, ]
            # 최빈값 계산
            mode_value <- names(sort(table(row_values), decreasing = TRUE))[1]
            result[[col]][missing_indices[i]] <- mode_value
          }
        }
      }
    }
    return(result)
    # 방법 4: 평균값
  } else if (result_type == 4) {
      # 원본 데이터 구조 복사
    result <- mice_result$data

    # 각 변수에 대해 평균값 계산
    for(col in names(result)) {
      # 숫자형 변수만 처리
      if(is.numeric(result[[col]]) && col %in% names(mice_result$imp)) {
        imputed_values <- mice_result$imp[[col]]
        missing_indices <- which(is.na(result[[col]]))
        if(length(missing_indices) > 0) {
          result[[col]][missing_indices] <- rowMeans(imputed_values)
        }
      }
    }
    return(result)
    # 방법 5: 모든 대치 세트를 개별적으로 저장
  } else if (result_type == 5) {
    all_datasets <- list()
    for(i in 1:mice_result$m) {
    all_datasets[[i]] <- complete(mice_result, i)
    # 개별 파일로 저장
    write.csv(all_datasets[[i]], 
              paste0("results/mice_imputation_set_", i, ".csv"), 
              row.names = FALSE)
    }
    return(all_datasets)
  
  }
}