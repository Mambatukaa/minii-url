import { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  ClipboardIcon,
  CheckIcon,
  LinkIcon,
  ArrowPathIcon
} from '@heroicons/react/24/outline';
import { Button } from '@material-tailwind/react';
import { useCopyToClipboard } from 'usehooks-ts';

function App() {
  const [longUrl, setLongUrl] = useState<string>('');
  const [shortUrl, setShortUrl] = useState<string>('');
  const [isLoading, setLoading] = useState<boolean>(false);
  const [isNewLink, setIsNewLink] = useState<boolean>(false);

  const [, copy] = useCopyToClipboard();

  const [copied, setCopied] = useState(false);

  const fetchShortUrl = async () => {
    console.log('Shorten URL', shortUrl);
    setLoading(true);

    if (!validateUrl(longUrl)) {
      setLoading(false);
      alert('Invalid URL');
      return;
    }

    setTimeout(() => {
      setLoading(false);
      setIsNewLink(true);

      setShortUrl('https://short.url/abc123');

      setTimeout(() => {
        setIsNewLink(false);
      }, 5000);
    }, 3000);
  };

  const validateUrl = (value: string): boolean => {
    return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(
      value
    );
  };

  return (
    <div className="flex h-screen justify-center items-center bg-[url('assets/background/bg-6.jpg')]">
      <div className="relative container h-[80%] flex flex-col rounded-xl shadow-lg items-center bg-[url('assets/background/bg-7.jpg')]">
        <h1 className="absolute top-48 font-serif text-6xl font-bold text-white">
          MinimURL
        </h1>

        <div className="flex flex-col w-1/2 m-auto">
          <h1 className="font-sans text-lg text-gray-200 text-center">
            MinimURL minimizes your URLs into short, manageable links for simple
            sharing.
          </h1>

          <div className="flex flex-row justify-between my-5 h-11">
            <div className={`relative w-[89%]`}>
              <div className="absolute inset-y-0 start-0 flex items-center ps-4 pointer-events-none">
                <LinkIcon className="h-4 w-4 text-gray-700" />
              </div>

              <input
                className="text-gray-300 h-11 font-sans w-full p-3 ps-10 placeholder-gray-700 bg-gray-900 border border-gray-700 rounded-lg leading-tight"
                type="url"
                placeholder="Enter your link here..."
                value={longUrl}
                onChange={e => setLongUrl(e.target.value)}
              />
            </div>

            <Button
              className={`flex items-center justify-center border border-gray-700 rounded-lg shadow bg-gray-900 w-[9%] text-sm font-semibold ${
                isLoading ? 'pointer-events-none opacity-50' : ''
              }`}
              type="button"
              onClick={() => fetchShortUrl()}
            >
              <ArrowPathIcon
                className={`${
                  isLoading ? 'animate-spin ' : ''
                } h-5 w-5 text-gray-300`}
              />
            </Button>
          </div>

          <div className="flex flex-row justify-between h-11">
            <Link
              to={shortUrl}
              target="_blank"
              className={`ps-5 font-sans flex items-center bg-gray-900 border-2 border-gray-700 rounded-lg w-[78%] leading-tight text-blue-300 ${
                isNewLink
                  ? 'animate-border bg-gradient-to-r from-red-500 via-purple-500 to-blue-500 bg-[length:400%_400%]'
                  : ''
              }`}
            >
              {shortUrl}
            </Link>

            <Button
              className={`flex font-sans items-center justify-center gap-3 p-2 border border-gray-700 rounded-lg shadow bg-gray-900 w-[20%] text-sm font-semibold text-gray-400 `}
              onClick={() => {
                copy(shortUrl);
                setCopied(true);
              }}
              onMouseLeave={() => setCopied(false)}
            >
              {copied ? (
                <>
                  <CheckIcon className="h-4 w-4 text-gray-300" />
                  Copied
                </>
              ) : (
                <>
                  <ClipboardIcon className="h-4 w-4 text-white" /> Copy Link
                </>
              )}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
