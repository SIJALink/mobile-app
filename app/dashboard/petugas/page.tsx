
"use client";

import { useState } from "react";

type Petugas = {
  id: number;
  nama: string;
  telepon: string;
  jabatan: string;
  status: string;
};

export default function DataPetugas() {
  const [data, setData] = useState<Petugas[]>([
    { id: 1, nama: "Andi Saputra", telepon: "081234567890", jabatan: "Teknisi", status: "Aktif" },
    { id: 2, nama: "Budi Santoso", telepon: "082345678901", jabatan: "Teknisi", status: "Aktif" },
    { id: 3, nama: "Dedi Kurniawan", telepon: "083456789012", jabatan: "Petugas Lapangan", status: "Tidak Aktif" },
    { id: 4, nama: "Rizky Pratama", telepon: "085678901234", jabatan: "Supervisor", status: "Aktif" },
  ]);

  const [nama, setNama] = useState("");
  const [telepon, setTelepon] = useState("");
  const [jabatan, setJabatan] = useState("Teknisi");
  const [status, setStatus] = useState("Aktif");
  const [cari, setCari] = useState("");
  const [editId, setEditId] = useState<number | null>(null);
  const [modal, setModal] = useState(false);

  const aktif = data.filter(p => p.status === "Aktif").length;
  const tidakAktif = data.length - aktif;

  const hasil = data.filter(p =>
    p.nama.toLowerCase().includes(cari.toLowerCase()) ||
    p.telepon.includes(cari)
  );

  function bukaTambah() {
    setEditId(null);
    setNama("");
    setTelepon("");
    setJabatan("Teknisi");
    setStatus("Aktif");
    setModal(true);
  }

  function bukaEdit(p: Petugas) {
    setEditId(p.id);
    setNama(p.nama);
    setTelepon(p.telepon);
    setJabatan(p.jabatan);
    setStatus(p.status);
    setModal(true);
  }

  function simpan(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();

    if (editId !== null) {
      setData(data.map(p =>
        p.id === editId
          ? { ...p, nama, telepon, jabatan, status }
          : p
      ));
    } else {
      setData([...data, {
        id: Date.now(),
        nama,
        telepon,
        jabatan,
        status
      }]);
    }

    setModal(false);
  }

  function hapus(id: number) {
    if (confirm("Yakin ingin menghapus data petugas?")) {
      setData(data.filter(p => p.id !== id));
    }
  }

  return (
    <main className="min-h-screen bg-[#f1f6ff] p-5 md:p-8">
      <div className="mx-auto max-w-7xl">

        <div className="mb-7">
          <h1 className="text-2xl font-bold text-[#0c326b]">
            Data Petugas
          </h1>
          <p className="mt-1 text-sm text-gray-500">
            Kelola seluruh data petugas SIJALink.
          </p>
        </div>

        {/* Ringkasan */}
        <div className="mb-6 grid grid-cols-1 gap-5 sm:grid-cols-3">
          {[
            { title: "Total Petugas", value: data.length, color: "text-blue-700" },
            { title: "Petugas Aktif", value: aktif, color: "text-green-600" },
            { title: "Tidak Aktif", value: tidakAktif, color: "text-red-500" },
          ].map(item => (
            <div key={item.title} className="rounded-xl border border-blue-100 bg-white p-5 shadow-sm">
              <p className="text-sm text-gray-500">{item.title}</p>
              <h2 className={`mt-2 text-3xl font-bold ${item.color}`}>
                {item.value}
              </h2>
            </div>
          ))}
        </div>

        {/* Tabel */}
        <section className="rounded-xl border border-blue-100 bg-white p-5 shadow-sm">

          <div className="mb-6 flex flex-col justify-between gap-4 md:flex-row">
            <div>
              <h2 className="text-lg font-bold text-[#0c326b]">
                Daftar Petugas
              </h2>
              <p className="text-sm text-gray-500">
                Informasi seluruh petugas SIJALink
              </p>
            </div>

            <button
              onClick={bukaTambah}
              className="rounded-lg bg-blue-700 px-5 py-3 text-sm font-semibold text-white hover:bg-blue-800"
            >
              + Tambah Petugas
            </button>
          </div>

          <input
            value={cari}
            onChange={e => setCari(e.target.value)}
            placeholder="Cari nama atau nomor telepon..."
            className="mb-5 w-full rounded-lg border border-gray-300 px-4 py-3 text-sm text-gray-800 outline-none focus:border-blue-600 md:max-w-sm"
          />

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-blue-50 text-[#0c326b]">
                <tr>
                  <th className="p-4">No</th>
                  <th className="p-4">Nama Petugas</th>
                  <th className="p-4">Telepon</th>
                  <th className="p-4">Jabatan</th>
                  <th className="p-4">Status</th>
                  <th className="p-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {hasil.map((p, index) => (
                  <tr key={p.id} className="border-b border-gray-100 hover:bg-blue-50">
                    <td className="p-4 text-gray-600">{index + 1}</td>
                    <td className="p-4 font-semibold text-gray-800">{p.nama}</td>
                    <td className="p-4 text-gray-600">{p.telepon}</td>
                    <td className="p-4 text-gray-600">{p.jabatan}</td>
                    <td className="p-4">
                      <span className={`rounded-full px-3 py-1 text-xs font-semibold ${
                        p.status === "Aktif"
                          ? "bg-green-100 text-green-700"
                          : "bg-red-100 text-red-600"
                      }`}>
                        {p.status}
                      </span>
                    </td>
                    <td className="p-4">
                      <div className="flex gap-2">
                        <button
                          onClick={() => bukaEdit(p)}
                          className="rounded-md bg-yellow-100 px-3 py-2 text-xs font-semibold text-yellow-700"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => hapus(p.id)}
                          className="rounded-md bg-red-100 px-3 py-2 text-xs font-semibold text-red-600"
                        >
                          Hapus
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}

                {hasil.length === 0 && (
                  <tr>
                    <td colSpan={6} className="p-8 text-center text-gray-500">
                      Data petugas tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* Modal Tambah dan Edit */}
        {modal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
            <form
              onSubmit={simpan}
              className="w-full max-w-md rounded-xl bg-white p-6 shadow-xl"
            >
              <h2 className="mb-5 text-xl font-bold text-[#0c326b]">
                {editId !== null ? "Edit Petugas" : "Tambah Petugas"}
              </h2>

              <label className="mb-2 block text-sm font-medium text-gray-700">
                Nama Petugas
              </label>
              <input
                required
                value={nama}
                onChange={e => setNama(e.target.value)}
                placeholder="Masukkan nama"
                className="mb-4 w-full rounded-lg border p-3 text-gray-800"
              />

              <label className="mb-2 block text-sm font-medium text-gray-700">
                Nomor Telepon
              </label>
              <input
                required
                value={telepon}
                onChange={e => setTelepon(e.target.value)}
                placeholder="Masukkan nomor telepon"
                className="mb-4 w-full rounded-lg border p-3 text-gray-800"
              />

              <label className="mb-2 block text-sm font-medium text-gray-700">
                Jabatan
              </label>
              <select
                value={jabatan}
                onChange={e => setJabatan(e.target.value)}
                className="mb-4 w-full rounded-lg border p-3 text-gray-800"
              >
                <option>Teknisi</option>
                <option>Petugas Lapangan</option>
                <option>Supervisor</option>
              </select>

              <label className="mb-2 block text-sm font-medium text-gray-700">
                Status
              </label>
              <select
                value={status}
                onChange={e => setStatus(e.target.value)}
                className="mb-6 w-full rounded-lg border p-3 text-gray-800"
              >
                <option>Aktif</option>
                <option>Tidak Aktif</option>
              </select>

              <div className="flex justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setModal(false)}
                  className="rounded-lg bg-gray-200 px-4 py-2 text-gray-700"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  className="rounded-lg bg-blue-700 px-5 py-2 text-white"
                >
                  Simpan
                </button>
              </div>
            </form>
          </div>
        )}

      </div>
    </main>
  );
}
