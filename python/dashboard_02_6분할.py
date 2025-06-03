import dash
from dash import dcc, html
import plotly.express as px
import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL 데이터베이스 연결 (SQLAlchemy 사용)
# 데이터 베이스 연결 객체
engine = create_engine('postgresql+psycopg2://postgres:test1234@localhost/apt')

# 쿼리 정의 (6개의 쿼리)
queries = [
    """
    SELECT
        EXTRACT(YEAR FROM TO_DATE(거래일, 'YYYY-MM-DD')) AS 거래연도,
        SUM(CAST(REPLACE(거래금액, ',', '') AS NUMERIC)) AS 연도별_거래금액
    FROM
        public.아파트_거래_01 아파트거래
    INNER JOIN
        public.시군구코드_01 시도
    ON
        아파트거래.지역코드 = 시도.지역코드
    GROUP BY
        EXTRACT(YEAR FROM TO_DATE(거래일, 'YYYY-MM-DD'))
    ORDER BY
        거래연도;
    """,
    """
    SELECT
        시도.시도 AS 지역,
        SUM(CAST(REPLACE(아파트거래.거래금액, ',', '') AS NUMERIC)) AS 총_거래금액
    FROM
        public.아파트_거래_01 아파트거래
    INNER JOIN
        public.시군구코드_01 시도
    ON
        아파트거래.지역코드 = 시도.지역코드
    GROUP BY
        시도.시도
    ORDER BY
        총_거래금액 DESC;
    """,
    """
    SELECT
        TO_CHAR(TO_DATE(거래일, 'YYYY-MM-DD'), 'YYYY-MM') AS 거래월,
        SUM(CAST(REPLACE(거래금액, ',', '') AS NUMERIC)) AS 월별_거래금액
    FROM
        public.아파트_거래_01 아파트거래
    INNER JOIN
        public.시군구코드_01 시도
    ON
        아파트거래.지역코드 = 시도.지역코드
    GROUP BY
        TO_CHAR(TO_DATE(거래일, 'YYYY-MM-DD'), 'YYYY-MM')
    ORDER BY
        거래월;
    """,
    """
    SELECT
        시도.시도 AS 지역,
        COUNT(*) AS 거래량
    FROM
        public.아파트_거래_01 아파트거래
    INNER JOIN
        public.시군구코드_01 시도
    ON
        아파트거래.지역코드 = 시도.지역코드
    GROUP BY
        시도.시도
    ORDER BY
        거래량 DESC;
    """,
    """
    SELECT
        ROUND(CAST(아파트거래.전용면적 AS NUMERIC), 1) AS 전용면적,
        AVG(CAST(REPLACE(아파트거래.거래금액, ',', '') AS NUMERIC)) AS 평균_거래금액,
        SUM(CAST(REPLACE(아파트거래.거래금액, ',', '') AS NUMERIC)) AS 총_거래금액,
        COUNT(*) AS 거래량
    FROM
        public.아파트_거래_01 아파트거래
    INNER JOIN
        public.시군구코드_01 시도
    ON
        아파트거래.지역코드 = 시도.지역코드
    GROUP BY
        ROUND(CAST(아파트거래.전용면적 AS NUMERIC), 1)
    ORDER BY
        전용면적;
    """,
    """
    WITH 거래_데이터 AS (
        SELECT
            아파트거래.건축년도,
            CAST(REPLACE(아파트거래.거래금액, ',', '') AS NUMERIC) AS 거래금액,
            COUNT(*) OVER (PARTITION BY 아파트거래.건축년도) AS 거래량,
            AVG(CAST(REPLACE(아파트거래.거래금액, ',', '') AS NUMERIC)) OVER (PARTITION BY 아파트거래.건축년도) AS 평균_거래금액,
            SUM(CAST(REPLACE(아파트거래.거래금액, ',', '') AS NUMERIC)) OVER (PARTITION BY 아파트거래.건축년도) AS 총_거래금액
        FROM
            public.아파트_거래_01 아파트거래
        INNER JOIN
            public.시군구코드_01 시도
        ON
            아파트거래.지역코드 = 시도.지역코드
    )
    SELECT DISTINCT ON (건축년도)
        건축년도,
        거래량,
        평균_거래금액,
        총_거래금액,
        SUM(거래금액) OVER (ORDER BY 건축년도) AS 누적_거래금액
    FROM
        거래_데이터
    ORDER BY
        건축년도;
    """
]

# 쿼리 실행 및 결과 데이터프레임 생성 (6개의 데이터프레임)
# queries 리스트에 저장된 6개의 SQL 쿼리를 실행하여 결과를 pandas 데이터프레임으로 변환합니다.
# 리스트 컴프리헨션을 사용하여 6개의 데이터프레임을 dfs 리스트에 저장합니다.
dfs = [pd.read_sql_query(query, engine) for query in queries]  # pd.read_sql_query 함수는 SQL 쿼리를 실행하고 결과를 데이터프레임으로 반환합니다.

# 그래프 생성 (6개의 그래프)
figs = [  # figs 리스트에 6개의 Plotly 그래프 객체를 생성하여 저장합니다.
    # 각 그래프는 dfs 리스트의 데이터프레임을 사용하여 생성됩니다.
    # px.line, px.bar, px.histogram 함수는 각각 선 그래프, 막대 그래프, 히스토그램을 생성합니다.
    px.line(dfs[0], x='거래연도', y='연도별_거래금액', title='연도별 거래금액'),
    px.bar(dfs[1], x='지역', y='총_거래금액', title='지역별 총 거래금액'),
    px.line(dfs[2], x='거래월', y='월별_거래금액', title='월별 거래금액'),
    px.bar(dfs[3], x='지역', y='거래량', title='지역별 거래량'),
    px.histogram(dfs[4], x='전용면적', y='평균_거래금액', title='전용면적별 평균 거래금액'),
    px.line(dfs[5], x='건축년도', y='누적_거래금액', title='건축년도별 누적 거래금액')
]

# 대시보드 앱 생성
app = dash.Dash(__name__)

# 대시보드 레이아웃 생성
app.layout = html.Div(children=[  # html.Div: HTML의 <div> 태그와 동일한 역할을 합니다. 여러 자식 요소를 포함할 수 있는 컨테이너입니다.
    html.H1(children='아파트 거래 대시보드'),  # html.H1: HTML의 <h1> 태그와 동일한 역할을 합니다. 대시보드의 제목을 표시합니다.

    html.Div(children=[
        dcc.Graph(  # dcc.Graph: Dash Core Components의 그래프 컴포넌트입니다. Plotly 그래프를 표시하는 데 사용됩니다.
            id='graph-1',
            figure=figs[0],
            style={'display': 'inline-block', 'width': '50%'}
        ),
        dcc.Graph(
            id='graph-2',
            figure=figs[1],
            style={'display': 'inline-block', 'width': '50%'}
        )
    ]),

    html.Div(children=[
        dcc.Graph(
            id='graph-3',  # id: 그래프의 고유 식별자입니다.
            figure=figs[2],  # figure: Plotly 그래프 객체를 지정합니다.
            style={'display': 'inline-block', 'width': '50%'}
            # style: CSS 스타일을 지정합니다. 여기서는 그래프를 인라인 블록으로 표시하고, 너비를 50%로 설정합니다.
        ),
        dcc.Graph(
            id='graph-4',
            figure=figs[3],
            style={'display': 'inline-block', 'width': '50%'}
        )
    ]),

    html.Div(children=[
        dcc.Graph(
            id='graph-5',
            figure=figs[4],
            style={'display': 'inline-block', 'width': '50%'}
        ),
        dcc.Graph(
            id='graph-6',
            figure=figs[5],
            style={'display': 'inline-block', 'width': '50%'}
        )
    ])
])

# 앱 실행
if __name__ == '__main__':
    app.run_server(debug=True)
