import qualified System.IO                  as IO
import qualified Data.List                  as L
import qualified Crypto.Hash                as Hash
import qualified Data.ByteString.Builder    as Builder
import qualified Data.ByteString            as B
import qualified Data.ByteString.Lazy       as LB
import qualified Data.ByteString.Lazy.Char8 as LP
import qualified Data.ByteString.Char8      as BP

candidates seed =
    [LB.append seed (Builder.toLazyByteString $ Builder.intDec x) | x <-[0..]]

md5 :: LB.ByteString -> Hash.Digest Hash.MD5
md5 = Hash.hashlazy

prefix = BP.pack "00000"

mineSuccess h = prefix == B.take 6 h

main :: IO ()
main = do
    seed <- IO.getLine
    let md5s = map (Hash.digestToHexByteString . md5) (candidates $ LP.pack seed)
    IO.print $ L.findIndex mineSuccess md5s
       
