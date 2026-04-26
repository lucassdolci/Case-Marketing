-- CAC POR CAMPANHA --
-- Fórmula: investimento / conversoes
-- Objetivo: Identificar as campanhas com maior e menor
--           custo por conversão, priorizando eficiência.

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
