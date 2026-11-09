module Popularidade
  ( tabela
  , pesquisa
  , go
  , main
  )
where

import System.IO (BufferMode (NoBuffering), hSetBuffering, stdout)
import Text.Printf (printf)

tabela :: String -> [(Int, String, Int)]
tabela texto = criarTabela 1 (lines texto)
  where
    criarTabela :: Int -> [String] -> [(Int, String, Int)]
    criarTabela _ [] = []
    criarTabela posicao (linha : restantes) =
      case words linha of
        [nome, quantidade] ->
          (posicao, nome, read quantidade)
            : criarTabela (posicao + 1) restantes
        _ -> criarTabela (posicao + 1) restantes

pesquisa :: String -> [(Int, String, Int)] -> String -> IO ()
pesquisa tipo tabelaDeNomes nome =
  procurar tabelaDeNomes
  where
    procurar [] =
      putStrLn (nome ++ " não encontrado entre " ++ tipo)

    procurar ((posicao, nomeTabela, quantidade) : restantes)
      | nome == nomeTabela =
          printf
            "%s classificado na posição %d entre %s com %d registros\n"
            nome posicao tipo quantidade
      | otherwise = procurar restantes

go :: [(Int, String, Int)] -> [(Int, String, Int)] -> IO ()
go tabGarotos tabGarotas = do
  putStr "Nome: "
  nome <- getLine

  if null nome
    then return ()
    else do
      pesquisa "garotas" tabGarotas nome
      pesquisa "garotos" tabGarotos nome
      go tabGarotos tabGarotas

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering

  boyNames <- readFile "boynames.txt"
  girlNames <- readFile "girlnames.txt"

  let tabGarotos = tabela boyNames
      tabGarotas = tabela girlNames

  go tabGarotos tabGarotas