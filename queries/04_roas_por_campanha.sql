-- ROAS POR CAMPANHA --
-- Fórmula: receita_gerada / investimento
-- Objetivo: Medir quanto cada real investido retornou
--           em receita. ROAS > 3 é considerado saudável.
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