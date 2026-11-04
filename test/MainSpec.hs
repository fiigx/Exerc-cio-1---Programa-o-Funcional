module Main (main) where

import Control.Exception (bracket)
import Run (runWithInput)
import System.Directory (createDirectory, removeDirectoryRecursive, withCurrentDirectory)
import System.FilePath ((</>))
import System.IO (writeFile)
import Test.Hspec
import qualified Popularidade as T

sampleBoys, sampleGirls :: String
sampleBoys = unlines ["Michael 42721", "Christopher 30993", "Jason 30043"]
sampleGirls = unlines ["Jessica 46914", "Jennifer 41584", "Amanda 33177"]

main :: IO ()
main = hspec $ do
  describe "tabela: processamento de arquivo" $ do
    it "atribui posições e interpreta quantidades" $
      T.tabela sampleBoys `shouldBe`
        [(1, "Michael", 42721), (2, "Christopher", 30993), (3, "Jason", 30043)]
    it "produz uma tabela vazia quando o arquivo não tem linhas" $
      T.tabela "" `shouldBe` []
    it "processa uma única entrada" $
      T.tabela "Ana 20\n" `shouldBe` [(1, "Ana", 20)]

  describe "pesquisa: consulta individual" $ do
    it "exibe a classificação quando o nome existe" $ do
      out <- runWithInput (T.pesquisa "garotas" (T.tabela sampleGirls) "Amanda") ""
      out `shouldContain` "Amanda classificado na posição 3 entre garotas com 33177 registros"
    it "informa quando o nome não é encontrado" $ do
      out <- runWithInput (T.pesquisa "garotos" (T.tabela sampleBoys) "Amanda") ""
      out `shouldContain` "Amanda não encontrado entre garotos"

  describe "main: interação completa" $ do
    it "consulta os dois arquivos e encerra com linha vazia" $ do
      let dir = "temp_test_dir"
          boys = dir </> "boynames.txt"
          girls = dir </> "girlnames.txt"
      let setup = do
            createDirectory dir
            writeFile boys sampleBoys
            writeFile girls sampleGirls
      let cleanup () = removeDirectoryRecursive dir
      bracket setup (\_ -> cleanup ()) $ \_ -> do
        out <- withCurrentDirectory dir $
          runWithInput T.main "Jason\nAmanda\n\n"
        out `shouldContain` "Jason classificado na posição 3 entre garotos com 30043 registros"
        out `shouldContain` "Jason não encontrado entre garotas"
        out `shouldContain` "Amanda não encontrado entre garotos"
        out `shouldContain` "Amanda classificado na posição 3 entre garotas com 33177 registros"
