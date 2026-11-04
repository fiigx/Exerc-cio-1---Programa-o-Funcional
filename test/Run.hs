module Run where

import Control.Applicative (liftA2)
import Control.Exception (bracket, finally)
import GHC.IO.Handle (hDuplicate, hDuplicateTo)
import System.IO (Handle, IOMode(ReadMode, WriteMode), hClose, stdin, stdout, withFile)
import System.IO.Temp (emptySystemTempFile, writeSystemTempFile)
import System.Process (readProcess)

-- | Redireciona temporariamente stdin e stdout para arquivos, executa uma
--   ação de IO e restaura os handles originais.
--   Esta versão é polimórfica e retorna o resultado da ação.
redirect :: IO a -> FilePath -> FilePath -> IO a
redirect action inputFileName outputFileName = do
  withFile inputFileName ReadMode $ \hIn ->
    withFile outputFileName WriteMode $ \hOut ->
      bracket
        (liftA2 (,) (hDuplicate stdin) (hDuplicate stdout))
        ( \(old_stdin, old_stdout) ->
            (hDuplicateTo old_stdin stdin >> hDuplicateTo old_stdout stdout)
              `finally` (hClose old_stdin >> hClose old_stdout)
        )
        ( \_ -> do
            hDuplicateTo hIn stdin
            hDuplicateTo hOut stdout
            action -- Agora 'action' é a última expressão, então o tipo 'a' é retornado
        )

-- | Executa uma ação de IO com uma string de entrada e captura a saída.
--   O resultado da ação original (se houver) é descartado.
runWithInput :: IO a -> String -> IO String
runWithInput action input = do
  inputFileName <- writeSystemTempFile "input.txt" input
  outputFileName <- emptySystemTempFile "output.txt"
  -- A ação é executada, mas seu resultado 'a' é ignorado.
  -- O importante é o efeito colateral (escrever no arquivo de saída).
  redirect (action >> return ()) inputFileName outputFileName
  readFile outputFileName
