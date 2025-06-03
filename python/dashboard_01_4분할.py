import dash
from dash import dcc, html
import plotly.express as px
import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL 데이터베이스 연결 (SQLAlchemy 사용)
engine = create_engine('postgresql+psycopg2://postgres:test1234@localhost/apt')

# 쿼리 정의 (4개의 쿼리) - 4개의 쿼리를 각각 정의
query1 = """
SELECT
    아파트거래.*,
    시도.시도,
    to_number(replace(아파트거래.거래금액, ',', ''), '999999999') as 거래금액_숫자
FROM
    아파트_거래_01 아파트거래
INNER JOIN
    시군구코드_01 시도
ON
    아파트거래.지역코드 = 시도.지역코드
WHERE
    시도.시도 = '서울특별시'
ORDER BY
    거래금액_숫자 DESC
LIMIT 1000;
"""

query2 = """
SELECT
    아파트거래.*,
    시도.시도,
    to_number(replace(아파트거래.거래금액, ',', ''), '999999999') as 거래금액_숫자
FROM
    아파트_거래_01 아파트거래
INNER JOIN
    시군구코드_01 시도
ON
    아파트거래.지역코드 = 시도.지역코드
WHERE
    시도.시도 = '서울특별시'
    AND 아파트거래.건축년도 = '1970'
    AND to_number(replace(아파트거래.거래금액, ',', ''), '999999999') > 100000
ORDER BY
    아파트거래.거래금액 ASC;
"""

query3 = """
SELECT
    extract(year from cast(아파트거래.거래일 as date)) as 거래연도,
    sum(to_number(replace(아파트거래.거래금액, ',', ''), '999999999')) as 연도별_거래금액
FROM
    아파트_거래_01 아파트거래
INNER JOIN
    시군구코드_01 시도
ON
    아파트거래.지역코드 = 시도.지역코드
WHERE
    시도.시도 = '서울특별시'
GROUP BY
    extract(year from cast(아파트거래.거래일 as date))
HAVING
    sum(to_number(replace(아파트거래.거래금액, ',', ''), '999999999')) > 0
ORDER BY
    거래연도;
"""

query4 = """
SELECT
    extract(year from cast(아파트거래.거래일 as date)) as 거래연도,
    count(*) as 연도별_거래건수
FROM
    아파트_거래_01 아파트거래
INNER JOIN
    시군구코드_01 시도
ON
    아파트거래.지역코드 = 시도.지역코드
WHERE
    시도.시도 = '서울특별시'
GROUP BY
    extract(year from cast(아파트거래.거래일 as date))
HAVING
    count(*) > 0
ORDER BY
    거래연도;
"""

# 쿼리 실행 (4개의 쿼리 실행) - 4개의 쿼리를 실행하고 결과를 DataFrame으로 변환
df1 = pd.read_sql_query(query1, engine)
df2 = pd.read_sql_query(query2, engine)
df3 = pd.read_sql_query(query3, engine)
df4 = pd.read_sql_query(query4, engine)

# 4개의 그래프를 생성하여 대시보드에 표시
fig1 = px.scatter(df1, x='거래금액_숫자', y='거래금액', title='서울특별시 아파트 거래금액 상위 1000건',
                  labels={'거래금액_숫자': '거래금액 (숫자)', '거래금액': '거래금액'},
                  color='거래금액_숫자', height=400)

fig2 = px.bar(df2, x='거래금액_숫자', y='거래금액', title='서울특별시 아파트 거래금액 (건축년도 1970)',
              labels={'거래금액_숫자': '거래금액 (숫자)', '거래금액': '거래금액'},
              color='거래금액_숫자', height=400)

fig3 = px.line(df3, x='거래연도', y='연도별_거래금액', title='서울특별시 연도별 거래금액',
               labels={'거래연도': '거래연도', '연도별_거래금액': '연도별 거래금액'},
               height=400)

fig4 = px.line(df4, x='거래연도', y='연도별_거래건수', title='서울특별시 연도별 거래건수',
               labels={'거래연도': '거래연도', '연도별_거래건수': '연도별 거래건수'},
               height=400)

# 대시보드 앱 생성
app = dash.Dash(__name__)

# 대시보드 레이아웃 생성 (4개의 그래프를 2x2로 배치) - 4개의 그래프를 2x2로 배치하여 대시보드 레이아웃 생성
app.layout = html.Div(children=[
    html.H1(children='아파트 거래 대시보드'),

    html.Div(children=[
        dcc.Graph(
            id='graph-1',
            figure=fig1,
            style={'display': 'inline-block', 'width': '50%'}
        ),
        dcc.Graph(
            id='graph-2',
            figure=fig2,
            style={'display': 'inline-block', 'width': '50%'}
        )
    ]),

    html.Div(children=[
        dcc.Graph(
            id='graph-3',
            figure=fig3,
            style={'display': 'inline-block', 'width': '50%'}
        ),
        dcc.Graph(
            id='graph-4',
            figure=fig4,
            style={'display': 'inline-block', 'width': '50%'}
        )
    ])
])

# 대시보드 앱 실행
if __name__ == '__main__':
    app.run_server(debug=True)