
"use client";

import { useState } from "react";

type Pengaduan = {
  id: number;
  nama: string;
  telepon: string;
  kategori: string;
  tanggal: string;
  lokasi: string;
  keluhan: string;
  status: string;
};

const dataAwal: Pengaduan[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    telepon: "081234567890",
    kategori: "Gangguan Internet",
    tanggal: "19-11-2026",
    lokasi: "Pasar Kemis",
    keluhan: "Internet tidak dapat digunakan sejak pagi.",
    status: "Menunggu",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    telepon: "082345678901",
    kategori: "Koneksi Lambat",
    tanggal: "18-11-2026",
    lokasi: "Rajeg",
    keluhan: "Koneksi internet sering mengalami gangguan.",
    status: "Diproses",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    telepon: "083456789012",
    kategori: "Pemasangan",
    tanggal: "17-11-2026",
    lokasi: "Sepatan",
    keluhan: "Meminta pengecekan pemasangan jaringan.",
    status: "Selesai",
  },
  {
    id: 4,
    nama: "Rizky Maulana",
    telepon: "084567890123",
    kategori: "Gangguan Internet",
    tanggal: "16-11-2026",
    lokasi: "Cikupa",
    keluhan: "Internet terputus beberapa kali.",
    status: "Menunggu",
  },
];

export default function PengaduanPage() {
  const [data, setData] = useState(dataAwal);
  const [cari, setCari] = useState("");
  const [pilihan, setPilihan] = useState<Pengaduan | null>(null);

  const jumlahMenunggu = data.filter(
    (item) => item.status === "Menunggu"
  ).length;

  const jumlahDiproses = data.filter(
    (item) => item.status === "Diproses"
  ).length;

  const jumlahSelesai = data.filter(
    (item) => item.status === "Selesai"
  ).length;

  const dataFilter = data.filter((item) =>
    `${item.nama} ${item.telepon} ${item.kategori}`
      .toLowerCase()
      .includes(cari.toLowerCase())
  );

  function ubahStatus(status: string) {
    if (!pilihan) return;

    setData((sebelumnya) =>
      sebelumnya.map((item) =>
        item.id === pilihan.id ? { ...item, status } : item
      )
    );

    setPilihan(null);
  }

  const statusStyle: Record<string, string> = {
    Menunggu: "bg-amber-100 text-amber-700",
    Diproses: "bg-blue-100 text-blue-700",
    Selesai: "bg-green-100 text-green-700",
  };

  return (
    <div className="min-h-screen bg-slate-50 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Admin
          </p>
          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Pengaduan Pelanggan
          </h1>
          <p className="mt-1 text-sm text-slate-500">
            Kelola dan pantau laporan pengaduan pelanggan.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Pengaduan</p>
            <h2 className="mt-2 text-3xl font-bold text-slate-800">
              {data.length}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Semua laporan pelanggan
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Menunggu</p>
            <h2 className="mt-2 text-3xl font-bold text-amber-600">
              {jumlahMenunggu}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Belum ditangani
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Diproses</p>
            <h2 className="mt-2 text-3xl font-bold text-blue-600">
              {jumlahDiproses}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Sedang ditangani
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Selesai</p>
            <h2 className="mt-2 text-3xl font-bold text-green-600">
              {jumlahSelesai}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Sudah diselesaikan
            </p>
          </div>
        </div>

        {/* TABEL */}
        <div className="overflow-hidden rounded-2xl bg-white shadow-sm">
          <div className="flex flex-col justify-between gap-4 border-b border-slate-100 p-5 md:flex-row md:items-center">
            <div>
              <h2 className="font-bold text-slate-800">
                Daftar Pengaduan
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Data laporan dari pelanggan
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama atau kategori..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-72"
            />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead className="bg-slate-50 text-slate-500">
                <tr>
                  <th className="px-5 py-4">Pelanggan</th>
                  <th className="px-5 py-4">Kategori</th>
                  <th className="px-5 py-4">Tanggal</th>
                  <th className="px-5 py-4">Lokasi</th>
                  <th className="px-5 py-4">Status</th>
                  <th className="px-5 py-4">Aksi</th>
                </tr>
              </thead>

              <tbody className="divide-y divide-slate-100">
                {dataFilter.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50">
                    <td className="px-5 py-4">
                      <p className="font-semibold text-slate-800">
                        {item.nama}
                      </p>
                      <p className="mt-1 text-xs text-slate-500">
                        {item.telepon}
                      </p>
                    </td>

                    <td className="px-5 py-4 text-slate-600">
                      {item.kategori}
                    </td>

                    <td className="px-5 py-4 text-slate-600">
                      {item.tanggal}
                    </td>

                    <td className="px-5 py-4 text-slate-600">
                      {item.lokasi}
                    </td>

                    <td className="px-5 py-4">
                      <span className={`rounded-full px-3 py-1 text-xs font-semibold ${statusStyle[item.status]}`}>
                        {item.status}
                      </span>
                    </td>

                    <td className="px-5 py-4">
                      <button
                        onClick={() => setPilihan(item)}
                        className="rounded-lg bg-blue-50 px-3 py-2 text-xs font-semibold text-blue-600 hover:bg-blue-100"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {dataFilter.length === 0 && (
                  <tr>
                    <td colSpan={6} className="p-8 text-center text-slate-500">
                      Data pengaduan tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* MODAL DETAIL */}
        {pilihan && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl">
              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Pengaduan
                </h2>
                <button
                  onClick={() => setPilihan(null)}
                  className="text-2xl text-slate-400 hover:text-slate-700"
                >
                  ×
                </button>
              </div>

              <div className="mt-5 space-y-4">
                <div>
                  <p className="text-xs text-slate-400">Nama Pelanggan</p>
                  <p className="font-semibold text-slate-800">{pilihan.nama}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Nomor Telepon</p>
                  <p className="text-slate-700">{pilihan.telepon}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Kategori</p>
                  <p className="text-slate-700">{pilihan.kategori}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Lokasi</p>
                  <p className="text-slate-700">{pilihan.lokasi}</p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Isi Pengaduan</p>
                  <p className="rounded-xl bg-slate-50 p-3 text-sm text-slate-700">
                    {pilihan.keluhan}
                  </p>
                </div>

                <div>
                  <label className="text-xs text-slate-400">
                    Ubah Status Pengaduan
                  </label>

                  <select
                    value={pilihan.status}
                    onChange={(e) => {
                      setPilihan({
                        ...pilihan,
                        status: e.target.value,
                      });
                    }}
                    className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm outline-none focus:border-blue-500"
                  >
                    <option value="Menunggu">Menunggu</option>
                    <option value="Diproses">Diproses</option>
                    <option value="Selesai">Selesai</option>
                  </select>
                </div>
              </div>

              <div className="mt-6 flex gap-3">
                <button
                  onClick={() => setPilihan(null)}
                  className="flex-1 rounded-xl border border-slate-200 py-3 text-sm font-semibold text-slate-600"
                >
                  Batal
                </button>

                <button
                  onClick={() => ubahStatus(pilihan.status)}
                  className="flex-1 rounded-xl bg-blue-600 py-3 text-sm font-semibold text-white hover:bg-blue-700"
                >
                  Simpan Status
                </button>
              </div>
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
