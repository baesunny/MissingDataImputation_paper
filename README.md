# 고비용 공정데이터 획득 환경에서 불완비 공정데이터의 효율적인 결측치 대체 방법

*An Efficient Method for Imputing Missing Values in Incomplete Process Data from High-Cost Data Acquisition Environments*

고비용·장기 누적 실험에서 흔한 **불완전 공정 데이터**의 독립변수 결측을, **MICE · missForest · 1D-CNN** 세 가지 대표 기법으로 대체·비교하였였다. 친환경 슬래그 시멘트(초속경성) 제조 현장에서 수집된 혼합형(연속·범주) 공정 변수를 대상으로, CTQ 예측에 앞서 결측 대체 품질을 실증한다.

**프로젝트 상태: 완료**

**논문 저자:** 배재호(오산대학교 안전보건관리학과) · 최선미((주)씨에스엠) · **배성윤**(국민대학교 AI빅데이터융합경영학과)

---

## 논문 문서

| 파일 | 설명 |
|------|------|
| [`docs/paper_jksie_2025_48-4_129-141.pdf`](docs/paper_jksie_2025_48-4_129-141.pdf) | 한국산업시스템공학회지 제48권 제4호(2025.12) 게재 논문 원고 (pp.129–141) |

---

## 발표 자료

| 파일 | 설명 |
|------|------|
| [`docs/presentation_intro_20250722.pdf`](docs/presentation_intro_20250722.pdf) | 결측치 대체 기법(MICE, MissForest, 1D-CNN) 소개 및 1D-CNN 실험 절차 요약 (2025-07-22) |

---

## 연구 요약

### 배경

- 양산·R&D 현장에서는 **데이터 1건 확보 비용**이 크고, 초기 설계에 없던 변수가 후속 연구에서 추가되며 **구조적 결측**이 누적된다.
- 단변량 평균·중앙값 대체는 분산 과소추정·상관 왜곡을 유발하므로, **다변량 대체(MICE, missForest)** 또는 **딥러닝(1D-CNN)** 이 필요하다.
- 본 연구 데이터는 슬래그 시멘트 공정의 **MCAR에 가까운 결측** 특성을 가지며, 표본 규모는 대용량 센서 로그 대비 **소규모**이다.

### 비교 대상

| 기법 | 구현·특징 |
|------|-----------|
| **MICE** | 변수별 연쇄 회귀(논문·R: `mice` 패키지 / Python: `sklearn.impute.IterativeImputer`) |
| **missForest** | 랜덤 포레스트 기반 비모수 다변량 대체(R: `missForest` / Python: `miceforest`) |
| **1D-CNN** | 평균으로 1차 채운 뒤 오토인코더형 1D CNN으로 재구성; 논문·노트북에서는 **1회·다회(예: 10회) 반복** 실험 |

### 1D-CNN 실험 절차

1. 결측 위치를 보존한 채 **평균으로 임시 대체**한 완전 행렬을 만든다.
2. 해당 행렬로 **1D-CNN을 학습**한다.
3. 예측값으로 **원래 결측 위치만** 갱신한다.
4. 필요 시 2–3단계를 **여러 회 반복**해 누적 대체 정확도를 비교한다(FM, MeanV, Density, Blain, HG, AG, DG, Gyp_per, WC_per 등).

### 주요 결론

- 세 기법 모두 **혼합형 소규모 공정 데이터**에서 결측을 복원할 수 있으나, 변수·결측 패턴에 따라 **오차(NRMSE·MAE 등)와 분포 보존** 성능이 달라진다.
- **MICE**는 해석·구현이 수월하고, **missForest**는 비선형 관계에 강건한 경우가 많으며, **1D-CNN**은 반복 학습 설정에 따라 일부 CTQ 관련 변수에서 경쟁력 있는 복원을 보인다(세부 수치는 논문 표·그래프 참조).

---

## 분석 파이프라인

| 단계 | 경로 | 내용 |
|------|------|------|
| 데이터 병합·전처리 | `notebooks/00_data_merge.ipynb` | 샘플 엑셀에서 독립변수 프레임 구성 |
| MICE | `notebooks/mice/` | sklearn MICE 예제, 대체별 분포 시각화 |
| 1D-CNN | `notebooks/cnn_1d/` | 1회·전체·반복 실험 노트북 |
| R 전처리·대체 | `R/01_data_preparation.ipynb` | MICE/missForest/1D-CNN(R) 통합 워크플로 |
| 일괄 Python | `scripts/data_prepare.py` | MICE / missForest / 1D-CNN / MLP 선택 실행 |

---

## 디렉터리 구조

```
MissingDataImputation_paper/
├── README.md
├── requirements.txt
├── .gitignore
├── docs/
│   ├── paper_jksie_2025_48-4_129-141.pdf
│   └── presentation_intro_20250722.pdf
├── data/
│   ├── Imputation_Test.xlsx      # 공개용 익명화 샘플 (실험 재현)
│   ├── ctp.csv, ctq.csv          # CTP·CTQ 구간별 중간 산출
│   ├── middle.csv, stocking.csv
├── sources/
│   └── Imputation_Test.xlsx      # data_prepare.py 입력용 복사본
├── scripts/
│   └── data_prepare.py           # Python 통합 대체·리포트
├── notebooks/
│   ├── 00_data_merge.ipynb
│   ├── mice/
│   │   ├── 01_mice_sklearn_example.ipynb
│   │   └── 02_mice_visualization.ipynb
│   └── cnn_1d/
│       ├── 01_cnn_imputation_once.ipynb
│       ├── 02_cnn_imputation_full.ipynb
│       └── 03_cnn_imputation_repeated.ipynb
├── R/
│   ├── 01_data_preparation.ipynb
│   └── custom_library/           # MICE 집계, 경로·한글·엑셀 유틸
└── outputs/
    ├── cnn_errors/               # 1D-CNN 반복 실험 오차 CSV·XLSX
    └── imputation_reports/       # 결측·분포·정제 리포트(PDF/XLSX)
```
---

## 기술 스택

- **Python:** pandas, scikit-learn, miceforest, PyTorch, matplotlib, seaborn, openpyxl
- **R:** mice, missForest, keras(1D-CNN 경로), openxlsx, ggplot2 (노트북·custom_library)
- **문서:** JKSIE 2025; DOI [10.11627/jksie.2025.48.4.129](https://doi.org/10.11627/jksie.2025.48.4.129)
