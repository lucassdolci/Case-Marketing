-- RANKING DE CAMPANHAS RUINS --
-- Critérios combinados: ROAS < 1.5 E CAC alto E baixo CTR
-- Objetivo: Identificar campanhas que drenam orçamento sem
--           retorno adequado e sugerir redistribuição.

WITH metricas AS (
    SELECT
        campanha_id,
        nome_campanha,
        plataforma,
        mes_ano,
        investimento_brl,
        conversoes,
        receita_gerada_brl,
        ROUND(receita_gerada_brl / NULLIF(investimento_brl, 0), 2)         AS roas,
        ROUND(investimento_brl / NULLIF(conversoes, 0), 2)                 AS cac,
        ROUND((cliques / NULLIF(impressoes, 0)) * 100, 4)                  AS ctr
    FROM campanhas_marketing
),
pontuacao AS (
    SELECT
        *,
        -- Score de ineficiência: quanto maior, pior a campanha
        (CASE WHEN roas < 1.5  THEN 3 WHEN roas < 2.5  THEN 1 ELSE 0 END
       + CASE WHEN cac  > 100  THEN 3 WHEN cac  > 60   THEN 1 ELSE 0 END
       + CASE WHEN ctr  < 0.15 THEN 2 ELSE 0 END)                         AS score_ineficiencia
    FROM metricas
)
SELECT
    campanha_id,
    nome_campanha,
    plataforma,
    mes_ano,
    investimento_brl                                                        AS verba_em_risco,
    roas,
    cac,
    ROUND(ctr, 2)                                                           AS ctr_pct,
    score_ineficiencia,
    CASE
        WHEN score_ineficiencia >= 5 THEN '🔴 Corte imediato — realocar verba'
        WHEN score_ineficiencia >= 3 THEN '🟡 Revisão urgente — testar criativos'
        WHEN score_ineficiencia >= 1 THEN '🟠 Monitorar — otimizar segmentação'
        ELSE '🟢 Manter — campanha saudável'
    END                                                                     AS recomendacao
FROM pontuacao
ORDER BY score_ineficiencia DESC, roas ASC;