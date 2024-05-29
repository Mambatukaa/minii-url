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
  const [loading, setLoading] = useState<boolean>(false);
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
    }, 5000);

    setShortUrl('https://short.url/abc123');
  };

  const validateUrl = (value: string): boolean => {
    return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(
      value
    );
  };

  return (
    <div id="contact" className="flex h-screen justify-center items-center ">
      <div className="container h-[80%] flex flex-row rounded-xl shadow-lg justify-center items-center bg-[url('assets/background/bg-7.jpg')]">
        <div className="flex flex-col w-1/2">
          <div className="">
            <h1 className="font-sans text-xl text-gray-200 text-center">
              The Simplest URL Shortner You Were Waiting For
            </h1>

            <div className="flex flex-row justify-between my-4 h-10">
              <div className="relative w-[89%]">
                <div className="absolute inset-y-0 start-0 flex items-center ps-4 pointer-events-none">
                  <LinkIcon className="h-4 w-4 text-gray-700" />
                </div>

                <input
                  className="text-gray-300 h-10 font-sans w-full p-3 ps-10 placeholder-gray-700 bg-gray-900 border border-gray-700 rounded-lg leading-tight"
                  type="url"
                  placeholder="Enter your link here..."
                  value={longUrl}
                  onChange={e => setLongUrl(e.target.value)}
                />
              </div>

              <Button
                className="flex items-center justify-center border border-gray-700 rounded-lg shadow bg-gray-900 w-[9%] text-sm font-semibold"
                type="button"
                onClick={() => fetchShortUrl()}
              >
                <ArrowPathIcon
                  className={`${
                    loading ? 'animate-spin' : ''
                  } h-5 w-5 text-gray-300`}
                />
              </Button>
            </div>

            <div className="flex flex-row justify-between h-10">
              <Link
                to={shortUrl}
                target="_blank"
                className="ps-5 font-sans flex items-center bg-gray-900 border border-gray-700 rounded-lg w-[78%] leading-tight text-blue-300"
              >
                {shortUrl}
              </Link>

              <Button
                className="flex font-sans items-center justify-center gap-3 p-2 border border-gray-700 rounded-lg shadow bg-gray-900 w-[20%] text-sm font-semibold text-gray-400"
                onClick={() => {
                  copy('Hello world');
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
    </div>
  );
}

export default App;
