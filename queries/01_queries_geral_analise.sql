-- ============================================================
-- CASE: ANÁLISE DE PERFORMANCE DE CAMPANHAS DE MARKETING
-- Plataformas: Meta | YouTube | Spotify
-- Período: Janeiro–Fevereiro 2025
-- Analista: Portfolio Case
-- ============================================================

-- ============================================================
-- QUERY 1: RECEITA E INVESTIMENTO TOTAL POR PLATAFORMA
-- Objetivo: Entender quais plataformas geram mais retorno
--           em receita e qual o volume de investimento alocado.
-- ============================================================
SELECT
    plataforma,
    COUNT(DISTINCT campanha_id)                        AS total_campanhas,
    SUM(investimento_brl)                              AS investimento_total,
    SUM(receita_gerada_brl)                            AS receita_total,
    SUM(receita_gerada_brl) - SUM(investimento_brl)    AS lucro_bruto,
    ROUND(
        (SUM(receita_gerada_brl) - SUM(investimento_brl))
        / SUM(investimento_brl) * 100, 2
    )                                                  AS roi_percentual
FROM campanhas_marketing
GROUP BY plataforma
ORDER BY receita_total DESC;


-- ============================================================
-- QUERY 2: CAC POR CAMPANHA (Custo de Aquisição de Cliente)
-- Fórmula: investimento / conversoes
-- Objetivo: Identificar as campanhas com maior e menor
--           custo por conversão, priorizando eficiência.
-- ============================================================
SELECT
    campanha_id,
    nome_campanha,
    plataforma,
    mes_ano,
    investimento_brl,
    conversoes,
    ROUND(investimento_brl / NULLIF(conversoes, 0), 2)  AS cac_brl,
    -- Classificação de eficiência baseada no CAC
    CASE
        WHEN ROUND(investimento_brl / NULLIF(conversoes, 0), 2) <= 30  THEN 'Excelente'
        WHEN ROUND(investimento_brl / NULLIF(conversoes, 0), 2) <= 60  THEN 'Bom'
        WHEN ROUND(investimento_brl / NULLIF(conversoes, 0), 2) <= 100 THEN 'Regular'
        ELSE 'Crítico'
    END                                                  AS classificacao_cac
FROM campanhas_marketing
ORDER BY cac_brl ASC;


-- ============================================================
-- QUERY 3: ROAS POR CAMPANHA (Return on Ad Spend)
-- Fórmula: receita_gerada / investimento
-- Objetivo: Medir quanto cada real investido retornou
--           em receita. ROAS > 3 é considerado saudável.
-- ============================================================
SELECT
    campanha_id,
    nome_campanha,
    plataforma,
    mes_ano,
    investimento_brl,
    receita_gerada_brl,
    ROUND(receita_gerada_brl / NULLIF(investimento_brl, 0), 2) AS roas,
    -- Sinalização de campanhas ruins (ROAS abaixo do ponto de equilíbrio)
    CASE
        WHEN ROUND(receita_gerada_brl / NULLIF(investimento_brl, 0), 2) >= 4.0 THEN 'Alta Performance'
        WHEN ROUND(receita_gerada_brl / NULLIF(investimento_brl, 0), 2) >= 2.5 THEN 'Performance Média'
        WHEN ROUND(receita_gerada_brl / NULLIF(investimento_brl, 0), 2) >= 1.0 THEN 'Abaixo do Esperado'
        ELSE 'ROAS Negativo — Candidata a Corte'
    END                                                          AS status_roas
FROM campanhas_marketing
ORDER BY roas DESC;


-- ============================================================
-- QUERY 4: CTR POR CAMPANHA (Click-Through Rate)
-- Fórmula: (cliques / impressoes) * 100
-- Objetivo: Avaliar a relevância criativa e a assertividade
--           da segmentação de cada campanha.
-- ============================================================
SELECT
    campanha_id,
    nome_campanha,
    plataforma,
    mes_ano,
    impressoes,
    cliques,
    ROUND((cliques / NULLIF(impressoes, 0)) * 100, 4) AS ctr_percentual,
    -- Benchmark de CTR por plataforma (valores de mercado)
    CASE plataforma
        WHEN 'Meta'     THEN 'Benchmark: ~0.90%'
        WHEN 'YouTube'  THEN 'Benchmark: ~0.65%'
        WHEN 'Spotify'  THEN 'Benchmark: ~0.25%'
        ELSE 'Sem benchmark definido'
    END                                                AS benchmark_plataforma
FROM campanhas_marketing
ORDER BY ctr_percentual DESC;


-- ============================================================
-- QUERY 5: RANKING DE CAMPANHAS RUINS — CANDIDATAS A CORTE
-- Critérios combinados: ROAS < 1.5 E CAC alto E baixo CTR
-- Objetivo: Identificar campanhas que drenam orçamento sem
--           retorno adequado e sugerir redistribuição.
-- ============================================================
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
