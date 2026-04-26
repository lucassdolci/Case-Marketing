-- RECEITA E INVESTIMENTO TOTAL POR PLATAFORMA --
-- Objetivo: Entender quais plataformas geram mais retorno
--         em receita e qual o volume de investimento alocado.

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
