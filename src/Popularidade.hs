module Popularidade
  ( tabela,
    pesquisa,
    go,
    main,
  )
where

import System.IO (BufferMode (NoBuffering), hSetBuffering, stdout)
import Text.Printf (printf)

-- (Defina aqui os sinônimos de tipo, se desejar)

-- | Converte o conteúdo de um arquivo de nomes em uma tabela de dados.
tabela :: String -> [(Int, String, Int)]
tabela texto = undefined

-- | Pesquisa um nome em uma tabela e imprime o resultado.
pesquisa :: String -> [(Int, String, Int)] -> String -> IO ()
pesquisa tipo tabelaDeNomes nome = undefined

-- | Ação recursiva que implementa o laço de interação com o usuário.
go :: [(Int, String, Int)] -> [(Int, String, Int)] -> IO ()
go tabGarotos tabGarotas = undefined

-- | Ação principal que orquestra o programa.
main :: IO ()
main = undefined
